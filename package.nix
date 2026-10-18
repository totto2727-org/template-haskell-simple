{ haskellPackages, lib }:

let
  source = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./src
      ./app
      ./test
      ./project.cabal
      ./package.yaml
      ./README.md
      ./LICENSE
    ];
  };
  package = haskellPackages.callCabal2nix "project" source { };
in
package.overrideAttrs (old: {
  meta = (old.meta or { }) // {
    description = "A simple Haskell command-line application";
    license = lib.licenses.mit;
    mainProgram = "project";
  };
})
