{
  description = "A simple Haskell CLI template using Cabal and hpack";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

  outputs =
    { nixpkgs, ... }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
      overlay = final: _previous: {
        project = final.callPackage ./package.nix { };
      };
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
    in
    {
      overlays.default = overlay;

      packages = forEachSystem (
        system:
        let
          pkgs = mkPkgs system;
        in
        rec {
          inherit (pkgs) project;
          default = project;
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = mkPkgs system;
          h = pkgs.haskellPackages;
        in
        rec {
          ci = default.overrideAttrs (_: { shellHook = ""; });
          default = pkgs.mkShell {
            packages = [
              (h.ghcWithPackages (p: [ p.hspec ]))
              pkgs.cabal-install
              h.hpack
              h.fourmolu
              h.hlint
              pkgs.just
              pkgs.nixfmt
            ];
            shellHook = ''
              # Enable Git Hook
              vp config
            '';
          };
        }
      );
    };
}
