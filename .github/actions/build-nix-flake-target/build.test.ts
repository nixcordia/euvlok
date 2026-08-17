import { describe, expect, test } from "bun:test";

process.env.CONFIGURATION_KIND = "nixos";
process.env.CONFIGURATION_NAME = "test-host";
process.env.CONFIGURATION_SYSTEM = "aarch64-linux";
process.env.GITHUB_OUTPUT = "/dev/null";
process.env.GITHUB_STEP_SUMMARY = "/dev/null";
const userAgent =
  "Mozilla/5.0 (X11; Linux x86_64) " +
  "AppleWebKit/537.36 (KHTML, like Gecko) " +
  "Chrome/151.0.0.0 Safari/537.36";

process.env.HYDRA_USER_AGENT = userAgent;
process.env.BUILD_TIMEOUT_SECONDS = "1";
process.env.BUILD_MAX_JOBS = "1";
process.env.BUILD_CORES = "1";

const {
  HydraClient,
  containsTransientFailure,
  derivationName,
  enforceStartupDelay,
  failedDerivation,
  hydraCandidates,
  lastBuildingDerivation,
  parseHydraIndex,
  plannedDerivations,
} = await import("./build");

const hash = "4izbdpi2g000qmaqwmwdzpfqm3dh2cg9";
const follyDrv = `/nix/store/${hash}-folly-2026.01.19.00.drv`;
const complexName = "Qt6_WebEngine++debug?lang=ja_JP-6.10.0";
const complexDrv = `/nix/store/${hash}-${complexName}.drv`;

describe("Hydra consultation pacing", () => {
  test("waits 45 seconds before production orchestration", async () => {
    const delays: number[] = [];

    await enforceStartupDelay({
      bypassForDevelopment: false,
      isGitHubActions: true,
      sleep: (milliseconds) => {
        delays.push(milliseconds);
        return Promise.resolve();
      },
    });

    expect(delays).toEqual([45_000]);
  });

  test("allows the explicit bypass only outside GitHub Actions", async () => {
    let slept = false;

    await enforceStartupDelay({
      bypassForDevelopment: true,
      isGitHubActions: false,
      sleep: () => {
        slept = true;
        return Promise.resolve();
      },
    });

    expect(slept).toBeFalse();
  });

  test("rejects the development bypass in GitHub Actions", async () => {
    await expect(
      enforceStartupDelay({
        bypassForDevelopment: true,
        isGitHubActions: true,
      }),
    ).rejects.toThrow("forbidden in GitHub Actions");
  });
});

describe("Nix build log parsing", () => {
  test("extracts and deduplicates planned derivations", () => {
    const output = `these 2 derivations will be built:\n  ${follyDrv}\n  ${follyDrv}`;
    expect(plannedDerivations(output)).toEqual([follyDrv]);
    expect(derivationName(follyDrv)).toBe("folly-2026.01.19.00");
  });

  test("accepts the complete Nix name alphabet and length boundary", () => {
    const maximumName = "x".repeat(207);
    const maximumDrv = `/nix/store/${hash}-${maximumName}.drv`;
    const tooLongDrv = `/nix/store/${hash}-${"x".repeat(208)}.drv`;
    const unicodeDrv = `/nix/store/${hash}-日本語パッケージ.drv`;
    const invalidNix32Drv = `/nix/store/${"e".repeat(32)}-otherwise-valid.drv`;
    const output = [
      complexDrv,
      maximumDrv,
      tooLongDrv,
      unicodeDrv,
      invalidNix32Drv,
    ].join("\n");

    expect(plannedDerivations(output)).toEqual([complexDrv, maximumDrv]);
    expect(derivationName(complexDrv)).toBe(complexName);
    expect(derivationName(maximumDrv)).toBe(maximumName);
    expect(derivationName(tooLongDrv)).toBeNull();
    expect(derivationName(unicodeDrv)).toBeNull();
    expect(derivationName(invalidNix32Drv)).toBeNull();
    for (const forbiddenName of [".", "..", ".-hidden", "..-hidden"]) {
      expect(
        derivationName(`/nix/store/${hash}-${forbiddenName}.drv`),
      ).toBeNull();
    }
  });

  test("does not mistake malformed Unicode paths for build failures", () => {
    const unicodeDrv = `/nix/store/${hash}-中文工具.drv`;
    const output =
      `building '${unicodeDrv}'...\n` +
      `error: builder for '${unicodeDrv}' failed with exit code 1`;

    expect(lastBuildingDerivation(output)).toBe("");
    expect(failedDerivation(output)).toBe("");
  });

  test("finds direct failures and the last active derivation", () => {
    const first = `/nix/store/${"a".repeat(32)}-first.drv`;
    const second = `/nix/store/${"b".repeat(32)}-second.drv`;
    const output = [
      `building '${first}'...`,
      `building '${second}'...`,
      `error: builder for '${second}' failed with exit code 1`,
    ].join("\n");

    expect(lastBuildingDerivation(output)).toBe(second);
    expect(failedDerivation(output)).toBe(second);
  });

  test.each([
    ["npm error EAI_AGAIN registry.npmjs.org", true],
    ["HTTP error 429 while downloading", true],
    ["No space left on device", true],
    ["compiler error: no matching function", false],
  ] as const)(
    "classifies infrastructure signature in %s",
    (output, expected) => {
      expect(containsTransientFailure(output)).toBe(expected);
    },
  );
});

describe("Hydra failure shortlist", () => {
  const index = `
    <table>
      <tr>
        <td><a href="https://hydra.nixos.org/build/341725750"><span>job</span></a></td>
        <td> folly-2026.01.19.00 </td>
        <td>aarch64-linux</td>
        <td>maintainer</td>
        <td><strong>Failed</strong></td>
      </tr>
      <tr><td><a href="https://hydra.nixos.org/build/1">job</a></td><td>folly-2026.01.19.00</td><td>x86_64-linux</td><td>maintainer</td><td>Failed</td></tr>
      <tr><td><a href="https://hydra.nixos.org/build/2">job</a></td><td>folly-2026.01.19.00</td><td>aarch64-linux</td><td>maintainer</td><td>Dependency failed</td></tr>
    </table>`;

  test("parses semantic HTML instead of depending on serialized markup", () => {
    expect(parseHydraIndex(index)[0]).toEqual({
      buildId: "341725750",
      name: "folly-2026.01.19.00",
      status: "Failed",
      system: "aarch64-linux",
    });
  });

  test("preserves Unicode, entities, and nested markup in display names", () => {
    const internationalIndex = `
      <table><tr>
        <td><a href="https://hydra.nixos.org/build/99">job</a></td>
        <td><span>日本語パッケージ</span> &amp; 中文工具</td>
        <td>aarch64-linux</td><td>maintainer</td><td>Failed</td>
      </tr></table>`;

    expect(parseHydraIndex(internationalIndex)).toEqual([
      {
        buildId: "99",
        name: "日本語パッケージ & 中文工具",
        status: "Failed",
        system: "aarch64-linux",
      },
    ]);
  });

  test("requires both the derivation name and native system", () => {
    expect(hydraCandidates(index, [follyDrv], "aarch64-linux")).toEqual([
      { buildId: "341725750", drvPaths: [follyDrv] },
    ]);
  });

  test("checks one Hydra build once when names collide", async () => {
    const firstDrv = `/nix/store/${"a".repeat(32)}-${complexName}.drv`;
    const exactDrv = `/nix/store/${"b".repeat(32)}-${complexName}.drv`;
    const collisionIndex = `
      <table><tr>
        <td><a href="https://hydra.nixos.org/build/77">job</a></td>
        <td>Qt6_WebEngine++debug&quest;lang&equals;ja_JP-6.10.0</td>
        <td>aarch64-linux</td>
        <td>maintainer</td><td>Failed</td>
      </tr></table>`;
    let requestCount = 0;
    const fetcher = (input: Request | string | URL): Promise<Response> => {
      requestCount += 1;
      return Promise.resolve(
        String(input) === "https://zh.fail/failed/all.html"
          ? new Response(collisionIndex)
          : Response.json({
              buildstatus: 1,
              drvpath: exactDrv,
              finished: true,
            }),
      );
    };
    const hydra = new HydraClient("aarch64-linux", userAgent, fetcher);

    expect(
      hydraCandidates(collisionIndex, [firstDrv, exactDrv], "aarch64-linux"),
    ).toEqual([{ buildId: "77", drvPaths: [firstDrv, exactDrv] }]);
    expect(await hydra.exactFailure([firstDrv, exactDrv])).toEqual({
      buildId: "77",
      drvPath: exactDrv,
      status: 1,
      url: "https://hydra.nixos.org/build/77",
    });
    expect(requestCount).toBe(2);
  });

  test("skips only after Hydra verifies the exact derivation", async () => {
    let requestCount = 0;

    const fetcher = async (
      input: Request | string | URL,
      init?: RequestInit,
    ): Promise<Response> => {
      requestCount += 1;
      expect(new Headers(init?.headers).get("User-Agent")).toBe(userAgent);

      if (String(input) === "https://zh.fail/failed/all.html") {
        return new Response(index, {
          headers: { "Content-Type": "text/html" },
        });
      }

      return Response.json({
        buildstatus: 1,
        drvpath: follyDrv,
        finished: true,
      });
    };
    const hydra = new HydraClient("aarch64-linux", userAgent, fetcher);

    expect(await hydra.exactFailure([follyDrv])).toEqual({
      buildId: "341725750",
      drvPath: follyDrv,
      status: 1,
      url: "https://hydra.nixos.org/build/341725750",
    });
    expect(requestCount).toBe(2);
  });

  test("fails open when Hydra returns an unexpected JSON shape", async () => {
    const fetcher = async (
      input: Request | string | URL,
    ): Promise<Response> => {
      if (String(input) === "https://zh.fail/failed/all.html") {
        return new Response(index);
      }
      return Response.json({ finished: "not-a-boolean" });
    };
    const hydra = new HydraClient("aarch64-linux", userAgent, fetcher);

    expect(await hydra.exactFailure([follyDrv])).toBeNull();
  });
});
