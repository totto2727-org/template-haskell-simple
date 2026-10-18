# template-haskell-simple initialization

## Template files

| File | Purpose |
| --- | --- |
| `README.md`, `AGENTS.md` | Template entry point and initialization instructions. |
| `README_TEMPLATE.md`, `AGENTS_TEMPLATE.md` | Documents to customize for the copied project. |
| `src/Project.hs`, `app/Main.hs`, `test/Spec.hs` | Starter library, command, and Hspec tests. |
| `package.yaml` | Maintained package definition for hpack. |
| `project.cabal` | Generated Cabal manifest, committed for Cabal and Nix consumers. |
| `cabal.project` | Local build policy and Hackage index cutoff. |
| `cabal.project.freeze` | Locked Cabal dependencies, including the Hspec test suite. |
| `Justfile` | Generation, formatting, validation, build, and test tasks. |
| `flake.nix`, `flake.lock` | Shared local and CI toolchain and pinned Nix inputs. |
| `package.nix` | Installable CLI package, also exposed through an overlay. |
| `.envrc` | Optional direnv entry point. |
| `.github/workflows/ci.yml` | Haskell validation using the Nix development shell. |
| `.github/workflows/flakehub-publish-rolling.yml.disabled` | Disabled optional FlakeHub publication. |
| `.gitignore`, `LICENSE` | Local output exclusions and license to review. |

## Initialization

### 1. Establish the project

Confirm the repository, Cabal package and command names, purpose, license, and publication targets.
Do not invent registry ownership or credentials.
Enter `nix develop` from the copied repository root before running project tasks.
Review `.envrc` before explicitly running `direnv allow`.
Manage GHC, cabal-install, hpack, Fourmolu, and HLint in Nix only.
Do not add ghcup, a separate GHC version pin, or a CI compiler matrix.

### 2. Replace metadata and starter files

Replace `project` in `package.yaml`, `cabal.project`, `Justfile`, `package.nix`, and the package and overlay attributes in `flake.nix`.
Replace the `Project` module and its imports if the new project needs another name.
Update `username/project`, author, maintainer, copyright, version, description, and license metadata.
Replace the starter implementation and tests, including the CLI output assertion in `just test`.
Keep `package.yaml` as the source of truth, run `just generate`, and remove the old Cabal manifest if the package name changed.
Never edit the generated Cabal manifest directly.

Retain package and overlay outputs for a distributable CLI.
If the project becomes a library only, remove unsupported CLI installation instructions and adjust the Nix package.
Keep shared `totto2727-org/monorepo` action references on `@main`.
Do not create `CLAUDE.md`.

### 3. Create the project documents

Customize `README_TEMPLATE.md` for the actual public behavior and supported installation paths.
Present Nix acquisition methods as alternatives and state that only one is needed.
Add Hackage installation or API links only if the package is published there.
Customize `AGENTS_TEMPLATE.md` for the source layout, development tasks, and project rules.
Remove placeholders and unsupported routes, retaining the provenance footers.
Configure or delete the disabled publishing workflow before replacing these template instructions:

```bash
rm README.md AGENTS.md
mv README_TEMPLATE.md README.md
mv AGENTS_TEMPLATE.md AGENTS.md
```

### 4. Validate

Run `just generate` and `just ci` inside `nix develop`.
`just fix` formats Haskell source, and `just check` aggregates independently selectable hpack, Cabal, Fourmolu, and HLint checks.
Run `nixfmt --check flake.nix package.nix` separately when changing Nix files.
Evaluate all supported development shells without building packages:

```bash
nix eval .#devShells --apply 'builtins.mapAttrs (_: shells: shells.default.drvPath)' --json --option allow-import-from-derivation false
```

Validate Nix package behavior separately with `nix build .#project` when packaging changes.
Package evaluation uses `callCabal2nix`, which requires import from derivation.
Run `nix flake check --no-build` after the package build to check host-system outputs.
Keep Nix package builds outside `just ci` and normal CI.
Run `nix flake update` only when updating Nix inputs, and commit `flake.lock` with the change.
When adding Hackage dependencies, run `cabal update`, select an `index-state` at least seven days old, run `cabal freeze --enable-tests`, and commit `cabal.project.freeze` with the package definition.
The Nix development shell provides Hspec with GHC from the same pinned package set.
Keep the Cabal freeze file compatible with that package set when updating dependencies.
Check links and remaining placeholders, then commit the initialized project.

## Optional publication

### Hackage

This template does not publish to Hackage.
Before adding publication, confirm package ownership and complete the package metadata.
Review `cabal sdist` output and run `cabal check` inside `nix develop`.
Do not publish or add credentials without explicit user authorization.
See the [Cabal package guide](https://cabal.readthedocs.io/en/stable/cabal-package-description-file.html).

### FlakeHub

Keep the workflow disabled until the project requests publication, or delete it.
Use the [FlakeHub publishing wizard](https://flakehub.com/new) to confirm repository visibility and the trusted organization binding.
Protect `main`, review the shared actions on `@main`, and pin third-party actions to audited commit SHAs before enabling publication.
Confirm job-scoped OIDC permissions and run `just ci` before renaming the disabled workflow to `flakehub-publish-rolling.yml`.
FlakeHub publication does not require Hackage publication.
