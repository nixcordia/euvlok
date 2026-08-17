# EUVlok

<p>
  <a href="https://github.com/euvlok/euvlok/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/euvlok/euvlok/ci.yml?branch=master&style=for-the-badge&label=ci&colorA=303446&colorB=a6d189"></a>
  <a href="https://github.com/euvlok/euvlok/issues"><img alt="Open issues" src="https://img.shields.io/github/issues/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=ef9f76"></a>
  <a href="https://github.com/euvlok/euvlok"><img alt="License" src="https://img.shields.io/github/license/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=8caaee"></a>
</p>

Shared NixOS, nix-darwin, and Home Manager configurations for a few friends' machines

> [!IMPORTANT]
> This is a live configuration, not a starter template. It includes personal defaults
> and SOPS-encrypted secrets, so copy modules deliberately.

## Quick Start

```sh
devenv shell
```

If devenv asks you to trust the checkout:

```sh
devenv allow
```

Format and check:

```sh
devenv tasks run devenv:treefmt:run
devenv test
```

Build a configuration:

```sh
nix build .#nixosConfigurations.blind-faith.config.system.build.toplevel
nix build .#darwinConfigurations.faputa.system
```

## Hosts

| Output           | Owner           | Platform         | CI runner          |
| ---------------- | --------------- | ---------------- | ------------------ |
| `blind-faith`    | `lay-by`        | `x86_64-linux`   | `ubuntu-latest`    |
| `unsigned-int16` | `ashuramaruzxc` | `aarch64-linux`  | `ubuntu-24.04-arm` |
| `unsigned-int32` | `ashuramaruzxc` | `x86_64-linux`   | `ubuntu-latest`    |
| `unsigned-int64` | `ashuramaruzxc` | `x86_64-linux`   | `ubuntu-latest`    |
| `faputa`         | `bigshaq9999`   | `aarch64-darwin` | `macos-latest`     |
| `unsigned-int8`  | `ashuramaruzxc` | `aarch64-darwin` | `macos-latest`     |

This table is represented in the typed `hostMetadata` output. The build workflow derives
its matrix from that output rather than duplicating the list

## Layout

| Path                                | Purpose                                      |
| ----------------------------------- | ---------------------------------------------|
| [`flake-modules/`](./flake-modules) | Public outputs and the typed host inventory. |
| [`hosts/`](./hosts)                 | Internal machine and personal profiles.      |
| [`modules/`](./modules)             | Shared NixOS, nix-darwin, and HM modules.    |
| [`lib/`](./lib)                     | Helpers and overlays.                        |
| [`secrets/`](./secrets)             | SOPS-encrypted secrets.                      |

## Public Outputs

```nix
inputs.euvlok.nixosModules.default
inputs.euvlok.darwinModules.default
inputs.euvlok.homeModules.default
inputs.euvlok.homeModules.integrated
inputs.euvlok.overlays.default
inputs.euvlok.flakeModules.default
inputs.euvlok.lib.supportedSystems
inputs.euvlok.hostMetadata
inputs.euvlok.hostChecks
```

Named modules such as `nixosModules.nvidia`, `darwinModules.system`, and
`homeModules.wm` can be imported independently. Run `nix flake show` for the full output
list

`homeModules.default` is self-contained for standalone Home Manager

`homeModules.integrated` is for `home-manager.users` under NixOS or nix-darwin with
`home-manager.useGlobalPkgs = true`

Personal profiles are intentionally internal and are not part of the public module API

Custom options live below `euvlok.nixos.*` and `euvlok.home.*`

## Determinate Nix

The default NixOS and nix-darwin modules use [Determinate
Nix](https://docs.determinate.systems/determinate-nix/), pinned by `flake.lock`. When
migrating an existing NixOS host, use its cache for the first switch:

```sh
sudo nixos-rebuild switch \
  --option extra-substituters https://install.determinate.systems \
  --option extra-trusted-public-keys \
    'cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=' \
  --flake .#HOST
```

After that, rebuild normally

Install Determinate separately on macOS before activating the nix-darwin configuration

## Evaluation Performance

The evaluation benchmark records warm no-cache timings, peak memory, and the same
evaluator allocation and call counters used by Nixpkgs. With Nix 2.30 or newer it also
collects a sampling profile and renders an SVG flamegraph when `flamegraph.pl` is on
`PATH` (it is included in this repository's devenv shell):

```sh
EVAL_RUNS=5 ./scripts/eval_performance.sh \
  .#darwinConfigurations.faputa.system.drvPath
```

Run Darwin evaluations locally. Run Linux evaluations on the Linux host, from its
`~/euvlok` checkout:

```sh
ssh evy@100.123.214.78
cd ~/euvlok
EVAL_RUNS=5 ./scripts/eval_performance.sh \
  .#nixosConfigurations.blind-faith.config.system.build.toplevel.drvPath
```

The output directory contains `summary.json`, the raw statistics and timing for
every run, and `profile.folded`. When the renderer is available it also contains the
interactive `profile.svg` flamegraph
