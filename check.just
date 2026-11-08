set shell := ["bash", "-euo", "pipefail", "-c"]

[default]
all: hpack cabal fourmolu hlint

hpack:
    hpack --silent - | diff -u project.cabal -

cabal:
    cabal check

fourmolu:
    fourmolu --mode check src app test

hlint:
    hlint src app test
