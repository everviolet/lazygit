{
  description = "development shell for evergarden port";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    evergarden-whiskers.url = "github:everviolet/whiskers";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      forAllSystems =
        function: lib.genAttrs lib.systems.flakeExposed (system: function nixpkgs.legacyPackages.${system});
      callPackage =
        pkgs: args:
        pkgs.callPackage args {
          evergarden-whiskers =
            inputs.evergarden-whiskers.packages.${pkgs.stdenv.hostPlatform.system}.default;
        } { };
    in
    {
      devShells = forAllSystems (pkgs: {
        default = callPackage pkgs (
          {
            mkShellNoCC,
            just,
            evergarden-whiskers,
            catppuccin-catwalk,
            ...
          }:
          mkShellNoCC {
            packages = [
              just
              evergarden-whiskers
              catppuccin-catwalk
            ];
          }
        );
      });
    };
}
