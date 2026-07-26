# EUVlok

<p>
  <a href="https://github.com/euvlok/euvlok/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/euvlok/euvlok/ci.yml?branch=master&style=for-the-badge&label=ci&colorA=303446&colorB=a6d189"></a>
  <a href="https://github.com/euvlok/euvlok/issues"><img alt="Open issues" src="https://img.shields.io/github/issues/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=ef9f76"></a>
  <a href="https://github.com/euvlok/euvlok"><img alt="License" src="https://img.shields.io/github/license/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=8caaee"></a>
</p>
EUVlok is a shared Nix flake for a few friends' machines. It contains NixOS,
nix-darwin, Home Manager, Chezmoi dotfiles, and small maintenance tools.

The point of keeping this together is practical: we can read each other's
configs, copy the parts that make sense, and move useful patterns into shared
modules instead of solving the same problems in separate repos.

This is not a starter template. It has real host configs, personal preferences,
encrypted secrets, and assumptions from the machines it serves. Copy pieces
carefully.

> [!IMPORTANT]
> Files under [`secrets/`](./secrets) are SOPS-encrypted and live next to the
> hosts that use them.

## Layout

| Path                                | What it is                                                    |
| ----------------------------------- | ------------------------------------------------------------- |
| [`flake.nix`](./flake.nix)          | Top-level flake wiring and inputs.                            |
| [`devenv.nix`](./devenv.nix)        | Contributor shell, formatters, and git hooks.                 |
| [`flake-modules/`](./flake-modules) | Flake-parts modules for hosts and public outputs.             |
| [`hosts/`](./hosts)                 | NixOS, nix-darwin, and Home Manager entrypoints and profiles. |
| [`modules/`](./modules)             | Reusable NixOS, nix-darwin, and Home Manager modules.         |
| [`dotfiles/`](./dotfiles)           | Chezmoi dotfiles and templates.                               |
| [`lib/`](./lib)                     | Shared Nix helpers.                                           |
| [`secrets/`](./secrets)             | SOPS-encrypted host and user secrets.                         |

## Quick Start

```sh
devenv shell
```

Managed Home Manager profiles install devenv and its automatic shell hook. For
other profiles, install devenv and add the hook for your shell as described in
the [auto-activation guide](https://devenv.sh/auto-activation/), then trust this
checkout once:

```sh
devenv allow
```

Format and run the development checks:

```sh
devenv tasks run devenv:treefmt:run
devenv test
```

Build a host:

```sh
nix build .#nixosConfigurations.blind-faith.config.system.build.toplevel
nix build .#darwinConfigurations.faputa.system
```

## Hosts

| Output           | Owner           | Platform   |
| ---------------- | --------------- | ---------- |
| `blind-faith`    | `lay-by`        | NixOS      |
| `unsigned-int16` | `ashuramaruzxc` | NixOS      |
| `unsigned-int32` | `ashuramaruzxc` | NixOS      |
| `unsigned-int64` | `ashuramaruzxc` | NixOS      |
| `faputa`         | `bigshaq9999`   | nix-darwin |
| `unsigned-int8`  | `ashuramaruzxc` | nix-darwin |

Home Manager modules are exposed for `ashuramaruzxc`, `bigshaq9999`, and
`lay-by`.

## Flake Outputs

Modules:

```nix
inputs.euvlok.nixosModules.default
inputs.euvlok.darwinModules.default
inputs.euvlok.homeModules.default
inputs.euvlok.homeModules.os
```

The `default` modules compose the full shared configuration. Named modules can
be imported independently when a consumer only needs one feature:

```nix
inputs.euvlok.nixosModules.nvidia
inputs.euvlok.darwinModules.system
inputs.euvlok.homeModules.catppuccin-gtk
inputs.euvlok.homeModules.languages
inputs.euvlok.homeModules.wm
```

Named modules include their shared prerequisites and provider-owned inputs, so
consumers do not need to reproduce this flake's internal input names or import
implementation files by relative path.

Nixpkgs overlay:

```nix
inputs.euvlok.overlays.default
```

Reusable flake-parts module:

```nix
inputs.euvlok.flakeModules.default
```

The default overlay provides the shared VS Code extensions, an `unstable`
package set, `eupkgs`, and the compatibility overrides used by the host
modules. To select a different unstable source:

```nix
inputs.euvlok.lib.overlays.mkNixpkgsOverlay {
  unstableSource = inputs.nixpkgs-unstable;
}
```

The shared Nix module uses Nix's native automatic build scheduling by default.
Hosts that need fixed limits can override it declaratively:

```nix
euvlok.nix.buildParallelism = {
  maxJobs = 4;
  cores = 8;
};
```

### Determinate Nix

Every NixOS host that imports `inputs.euvlok.nixosModules.default` uses
[Determinate Nix](https://docs.determinate.systems/determinate-nix/). Its
version is pinned by `flake.lock`, and the shared module enables lazy trees,
all-core parallel evaluation, and weekly multi-threaded store optimisation.
Existing caches, registries, credentials, and host-specific Nix settings remain
declarative: the Determinate module writes them to its supported
`/etc/nix/nix.custom.conf` include.

The first switch from upstream Nix needs Determinate's binary cache so the
machine does not build Determinate Nix from source:

```sh
sudo nixos-rebuild switch \
  --option extra-substituters https://install.determinate.systems \
  --option extra-trusted-public-keys \
    'cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=' \
  --flake .#HOST
```

Later rebuilds use the normal command. Confirm the activated distribution with
`nix --version` and `determinate-nixd version`.

## Working Here

- Keep host-specific choices close to the host or user that needs them.
- Move repeated behavior into `modules/` or `lib/` once more than one setup uses
  it.
- Leave enough context that someone else in the repo can understand why a
  setting exists.
- Treat automation as source code and test behavior that can drift.
- Prefer explicit flake outputs over local conventions.
- Read the host that consumes a module before copying it somewhere else.

### Module metadata

Every module expression carries three top-level fields:

- `_class` prevents importing NixOS, nix-darwin, Home Manager, or flake-parts
  modules into the wrong evaluator. Cross-platform modules use `null`.
- `_file` preserves the real source location when a module is imported or
  wrapped before evaluation, which keeps diagnostics actionable.
- `key` gives the module a stable identity for import de-duplication and
  `disabledModules`.

These fields belong to module expressions only. Flakes, overlays, package/data
sets, source catalogs, and `nixosSystem`/`darwinSystem` builders are ordinary
Nix values and must not receive module metadata.

## Resources

- [nix.dev](https://nix.dev/)
- [NixOS Wiki](https://wiki.nixos.org/wiki/NixOS_Wiki)
- [Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/)
- [Home Manager options](https://home-manager-options.extranix.com/)
- [Noogle](https://noogle.dev/)
