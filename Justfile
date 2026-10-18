set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

# package.yaml is the source of truth. Commit the generated Cabal file.
generate:
    hpack

fix:
    fourmolu --mode inplace src app test
    hlint src app test
    nixfmt flake.nix package.nix

check:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p tmp
    manifest=$(mktemp tmp/manifest.XXXXXX)
    trap 'rm -f "$manifest"' EXIT
    hpack --silent - > "$manifest"
    diff -u project.cabal "$manifest"
    cabal check
    fourmolu --mode check src app test
    hlint src app test
    nixfmt --check flake.nix package.nix

build: generate
    cabal build all

test: generate
    cabal test all
    test "$(cabal run --verbose=0 exe:project)" = 'Hello, world!'

run: generate
    cabal run exe:project

ci: check build test
