#!/usr/bin/env bash
# shellcheck shell=bash
#
# Benchmark a Nix installable and optionally capture an evaluator flamegraph.

set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLATFORM="$(uname -s)"
readonly SCRIPT_DIR PLATFORM

fail() {
  echo "$*" >&2
  return 2
}

# Run one evaluation and normalize its timing and evaluator statistics.
# Globals:
#   PLATFORM, SCRIPT_DIR
# Arguments:
#   Installable, output directory, series name, and run number.
# Outputs:
#   Progress to stderr and measurement files under the output directory.
run_eval() {
  local -r installable="$1" output_dir="$2" series="$3" run="$4"
  local -r prefix="${output_dir}/${series}/${run}"
  local -r stats="${prefix}.stats.json" timing="${prefix}.time.txt"
  local wall_seconds max_rss_bytes max_rss_kib
  local peak_footprint_bytes='null'

  echo "${series} ${run}: ${installable}" >&2
  case "${PLATFORM}" in
    Darwin)
      /usr/bin/time -lp -o "${timing}" \
        env NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH="${stats}" \
        nix eval --no-eval-cache --raw "${installable}" >"${prefix}.out"
      wall_seconds="$(awk '$1 == "real" { print $2 }' "${timing}")"
      max_rss_bytes="$(awk '/maximum resident/ { print $1 }' "${timing}")"
      peak_footprint_bytes="$(awk '/peak memory/ { print $1 }' "${timing}")"
      ;;
    Linux)
      /usr/bin/time -f $'real %e\nuser %U\nsys %S\nmax_rss_kib %M' \
        -o "${timing}" env NIX_SHOW_STATS=1 NIX_SHOW_STATS_PATH="${stats}" \
        nix eval --no-eval-cache --raw "${installable}" >"${prefix}.out"
      wall_seconds="$(awk '$1 == "real" { print $2 }' "${timing}")"
      max_rss_kib="$(awk '$1 == "max_rss_kib" { print $2 }' "${timing}")"
      max_rss_bytes="$((max_rss_kib * 1024))"
      ;;
    *)
      echo "unsupported platform: ${PLATFORM}" >&2
      return 2
      ;;
  esac

  jq --from-file "${SCRIPT_DIR}/eval-run.jq" \
    --arg platform "${PLATFORM}" --argjson run "${run}" \
    --argjson wallSeconds "${wall_seconds}" \
    --argjson maxRssBytes "${max_rss_bytes}" \
    --argjson peakFootprintBytes "${peak_footprint_bytes}" \
    "${stats}" >"${prefix}.metrics.json"
}

main() {
  if (($# < 1 || $# > 2)); then
    echo "usage: $0 INSTALLABLE [OUTPUT_DIRECTORY]" >&2
    return 2
  fi

  local -r installable="$1"
  local -r output_dir="${2:-${TMPDIR:-/tmp}/euvlok-eval-$$}"
  local -r runs="${EVAL_RUNS:-5}" warmups="${EVAL_WARMUPS:-1}"
  local -r profile="${EVAL_PROFILE:-1}"
  local -i run

  [[ "${runs}" =~ ^[1-9][0-9]*$ ]] || fail 'EVAL_RUNS must be positive'
  [[ "${warmups}" =~ ^[0-9]+$ ]] || fail 'EVAL_WARMUPS must be non-negative'
  [[ "${profile}" =~ ^[01]$ ]] || fail 'EVAL_PROFILE must be 0 or 1'
  [[ ! -e "${output_dir}" ]] || fail 'output directory already exists'
  mkdir -p "${output_dir}"/{runs,warmups}
  for ((run = 1; run <= warmups; run++)); do
    run_eval "${installable}" "${output_dir}" warmups "${run}"
  done
  for ((run = 1; run <= runs; run++)); do
    run_eval "${installable}" "${output_dir}" runs "${run}"
  done
  jq -s --from-file "${SCRIPT_DIR}/eval-summary.jq" \
    --arg installable "${installable}" --arg platform "${PLATFORM}" \
    --argjson warmups "${warmups}" "${output_dir}"/runs/*.metrics.json \
    >"${output_dir}/summary.json"

  if ((profile == 1)); then
    nix eval --no-eval-cache --eval-profiler flamegraph \
      --eval-profile-file "${output_dir}/profile.folded" \
      --raw "${installable}" >"${output_dir}/profile.out"
    if command -v flamegraph.pl >/dev/null; then
      flamegraph.pl --title "Nix evaluation: ${installable}" \
        "${output_dir}/profile.folded" >"${output_dir}/profile.svg"
    fi
  fi
  echo "results: ${output_dir}" >&2
  jq . "${output_dir}/summary.json"
}

main "$@"
