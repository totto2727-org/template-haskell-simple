{ haskellPackages, lib }:

let
  source = lib.cleanSourceWith {
    src = lib.cleanSource ./.;
    filter =
      path: _type:
      !(builtins.elem (baseNameOf path) [
        "dist-newstyle"
        ".direnv"
        "tmp"
      ]);
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
