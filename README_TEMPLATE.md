# username/project

Replace this paragraph with the command's purpose and intended users.

## Usage

```console
$ project
Hello, world!
```

## Key features

- Replace this item with a user-visible capability.

## Prerequisites

- Nix with flakes enabled for the setup methods below.

## Setup

Choose one method. You do not need to complete all three.
Supported systems are `aarch64-darwin`, `aarch64-linux`, and `x86_64-linux`.

### Run without installing

```bash
nix run github:username/project
```

### Install

```bash
nix profile install github:username/project
```

### Nix flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    project.url = "github:username/project";
  };

  outputs = { nixpkgs, project, ... }:
    let
      system = "aarch64-darwin"; # Use your supported host system.
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ project.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.project ];
      };
    };
}
```

## Command reference

The starter command takes no arguments and writes `Hello, world!` followed by a newline to standard output.
It exits successfully after writing the greeting.
Replace this section with the complete public command behavior, options, exit statuses, and error contract.

## Development

See [AGENTS.md](./AGENTS.md) for repository structure and development commands.

## License

[MIT](./LICENSE)

_Based on the [share-artifact skill](https://github.com/totto2727-org/agent/tree/main/plugins/totto2727-coding/skills/share-artifact)._
