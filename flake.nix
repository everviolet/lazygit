{
  description = "development shell for evergarden port";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    evergarden-whiskers.url = "github:everviolet/whiskers";
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;

      forAllSystems =
        function:
        lib.genAttrs lib.systems.flakeExposed (system: function inputs.nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            just
            catppuccin-catwalk
            inputs.evergarden-whiskers.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        };
      });
    };
}
