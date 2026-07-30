# EUVlok

<p>
  <a href="https://github.com/euvlok/euvlok/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/euvlok/euvlok/ci.yml?branch=master&style=for-the-badge&label=ci&colorA=303446&colorB=a6d189"></a>
  <a href="https://github.com/euvlok/euvlok/issues"><img alt="Open issues" src="https://img.shields.io/github/issues/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=ef9f76"></a>
  <a href="https://github.com/euvlok/euvlok"><img alt="License" src="https://img.shields.io/github/license/euvlok/euvlok?style=for-the-badge&colorA=303446&colorB=8caaee"></a>
</p>

Shared NixOS, nix-darwin, and Home Manager configurations for a few friends'
machines.

> [!IMPORTANT]
> This is a live configuration, not a starter template. It includes personal
> defaults and SOPS-encrypted secrets, so copy modules deliberately.

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
nix flake check --all-systems --no-build
```

Build a configuration:

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

## Layout

| Path                                | Purpose                                   |
| ----------------------------------- | ----------------------------------------- |
| [`flake-modules/`](./flake-modules) | Hosts and public flake outputs.           |
| [`hosts/`](./hosts)                 | Per-machine and per-user configuration.   |
| [`modules/`](./modules)             | Shared NixOS, nix-darwin, and HM modules. |
| [`lib/`](./lib)                     | Helpers and overlays.                     |
| [`secrets/`](./secrets)             | SOPS-encrypted secrets.                   |

## Public Outputs

```nix
inputs.euvlok.nixosModules.default
inputs.euvlok.darwinModules.default
inputs.euvlok.homeModules.default
inputs.euvlok.overlays.default
inputs.euvlok.flakeModules.default
inputs.euvlok.lib.supportedSystems
```

Named modules such as `nixosModules.nvidia`, `darwinModules.system`, and
`homeModules.wm` can be imported independently. Run `nix flake show` for the
full output list.

## Determinate Nix

The default NixOS and nix-darwin modules use
[Determinate Nix](https://docs.determinate.systems/determinate-nix/), pinned by
`flake.lock`. When migrating an existing NixOS host, use its cache for the first
switch:

```sh
sudo nixos-rebuild switch \
  --option extra-substituters https://install.determinate.systems \
  --option extra-trusted-public-keys \
    'cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=' \
  --flake .#HOST
```

After that, rebuild normally. Install Determinate separately on macOS before
activating the nix-darwin configuration.
