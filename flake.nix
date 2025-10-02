{
  description = "A flake for building and running the C program, extract-xiso";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "extract-xiso";
        version = "2.7.1";

        src = ./.;

        nativeBuildInputs = [
          pkgs.cmake
          pkgs.gnumake
        ];

        buildInputs = [
          pkgs.gcc
        ];

        buildPhase = ''
          runHook preBuild
          cmake .
          make
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp extract-xiso $out/bin/
          runHook postInstall
        '';
      };
    }
    );
}
