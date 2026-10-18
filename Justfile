set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

# package.yaml is the source of truth. Commit the generated Cabal file.
generate:
    hpack

fix:
    fourmolu --mode inplace src app test

check: check-hpack check-cabal check-fourmolu check-hlint

check-hpack:
    hpack --silent - | diff -u project.cabal -

check-cabal:
    cabal check

check-fourmolu:
    fourmolu --mode check src app test

check-hlint:
    hlint src app test

build: generate
    cabal build all

test: generate
    cabal test all
    test "$(cabal run --verbose=0 exe:project)" = 'Hello, world!'

run: generate
    cabal run exe:project

ci: check build test
