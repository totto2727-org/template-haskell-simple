# username/project

## Repository structure

```text
src/                Library modules
app/Main.hs         Command entry point
test/Spec.hs        hspec-discover entry point
test/ProjectSpec.hs Native Hspec specifications
package.yaml        Maintained hpack package definition
project.cabal       Generated Cabal manifest
cabal.project       Build policy and Hackage index cutoff
cabal.project.freeze Locked Cabal dependencies
Justfile            Development tasks
flake.nix           Toolchain, package, and overlay outputs
flake.lock          Pinned Nix inputs
package.nix         Installable Nix package
.github/workflows/  CI and optional publication
```

Replace these paths with the initialized project's actual layout.

## Development commands

Run commands from the repository root inside `nix develop`.
Run `cabal update` on first use to prepare the Hackage index for Cabal build-tool resolution.
Local development and CI use the same Nix inputs for GHC, cabal-install, hpack, Fourmolu, and HLint.
Do not install or select a compiler with ghcup.

| Command | Result |
| --- | --- |
| `just generate` | Generate the Cabal manifest from `package.yaml`. |
| `just fix` | Format Haskell source with Fourmolu. |
| `just check` | Check manifest synchronization, package metadata, formatting, and lint findings without changing sources. |
| `just check-hpack` | Compare hpack output with the committed manifest without changing it. |
| `just check-cabal` | Validate Cabal package metadata. |
| `just check-fourmolu` | Check Haskell formatting. |
| `just check-hlint` | Report HLint suggestions. |
| `just build` | Generate the manifest and build all components. |
| `just test` | Generate the manifest, run Hspec tests, and check the starter CLI output. |
| `just run` | Run the command from source. |
| `just ci` | Check, build, and test without Nix package builds. |
| `nix build .#project` | Build the installable Nix package separately. |
| `nix run .` | Run the Nix package separately. |
| `nixfmt flake.nix package.nix` | Format Nix files separately. |
| `nixfmt --check flake.nix package.nix` | Check Nix formatting separately. |

## Architecture

- Keep command I/O in `app/` and reusable pure logic in `src/`.
- Test public behavior rather than implementation details.
- Use Hspec `describe`, `it`, and native expectations such as `shouldBe` for native tests.
- Keep `test/Spec.hs` limited to the discovery pragma; add test bodies in `*Spec.hs` modules that export `spec :: Spec`.
- Keep Docker or live-service tests outside default `test` and `ci` tasks.
- Keep package and overlay outputs for CLI distribution.
- Keep `package.nix` source inputs explicit with `lib.fileset`: select source directories as a whole and list required package files separately.
- Keep Nix package validation separate from Just and normal CI.
- Keep `fix` limited to automatic source changes and put read-only HLint checks in `check-hlint`.
- Keep Nix formatting outside the Haskell task graph, using the direct commands above.

## Package rules

### CI and publication policy

- Keep the inherited CI and publication workflows unchanged by default.
- Do not replace publication on pushes to `main` with tag or release triggers. Preserve existing tag triggers where already configured.
- Change workflows only for an explicit user request or a demonstrated project requirement, and explain why the change is necessary.
- Publication setup does not justify unrelated CI changes.

### Haskell rules

- Edit `package.yaml`, not `project.cabal`, and commit both after `just generate`.
- Keep GHC and bundled base library compatibility aligned with the package set in `flake.lock`.
- Keep Hspec in the Nix GHC package environment aligned with `package.yaml` and `cabal.project.freeze`.
- Update Nix tools through `flake.lock`, not a separate CI toolchain definition.
- After adding external dependencies, use a Hackage `index-state` at least seven days old, run `cabal freeze --enable-tests`, and commit the freeze file.
- Review dependency bounds instead of using `allow-newer` to bypass them.
- Keep optional publication disabled until repository settings and ownership are confirmed.
- Review shared actions on `@main` and pin third-party actions to audited commit SHAs before enabling publication.
- Replace the starter CLI assertion and this placeholder guidance with project-specific rules.

_Based on the [share-artifact skill](https://github.com/totto2727-org/agent/tree/main/plugins/totto2727-coding/skills/share-artifact)._
