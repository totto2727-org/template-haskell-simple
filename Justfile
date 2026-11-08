set shell := ["bash", "-euo", "pipefail", "-c"]

mod check 'check.just'

default:
    @just --list --list-submodules

# package.yaml is the source of truth. Commit the generated Cabal file.
generate:
    hpack

fix:
    fourmolu --mode inplace src app test

build: generate
    cabal build all

test: generate
    cabal test all
    test "$(cabal run --verbose=0 exe:project)" = 'Hello, world!'

run: generate
    cabal run exe:project

ci: check::all build test
