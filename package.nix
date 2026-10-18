{ haskellPackages, lib }:

let
  package = haskellPackages.callCabal2nix "project" (lib.cleanSource ./.) { };
in
package.overrideAttrs (old: {
  meta = (old.meta or { }) // {
    description = "A simple Haskell command-line application";
    license = lib.licenses.mit;
    mainProgram = "project";
  };
})
