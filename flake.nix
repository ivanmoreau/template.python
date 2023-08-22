{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      perSystem = { pkgs, lib, config, system, ... }: {
        overlayAttrs = {
          # Use python38 for poetry
          poetry = pkgs.poetry.override { python = pkgs.python38; };
        };
        devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              poetry
              python38
            ];
          };
      };
    };
}
