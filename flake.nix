# inspired by https://www.nmattia.com/posts/2022-12-18-lockfile-trick-package-npm-project-with-nix/
{
  description = "The Gren programming language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    systems,
    nixpkgs,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgJson = builtins.fromJSON (builtins.readFile ./package.json);
    pkgLock = builtins.fromJSON (builtins.readFile ./package-lock.json);
    nodePkg = "nodejs_20";
  in {
    devShells = eachSystem (system: {
      default = with import nixpkgs {inherit system;};
        mkShell {
          buildInputs = [
            pkgs.${nodePkg}
            pkgs.alejandra
          ];
        };
    });
    packages = eachSystem (system: {
      default = with import nixpkgs {inherit system;}; let
        # Download all packages that end up in node_modules so they can be
        # pulled from cache in the build phase when we are sandboxed.
        gren = pkgs.fetchurl {
          url = pkgLock.packages.${"node_modules/gren-lang"}.resolved;
          hash = pkgLock.packages.${"node_modules/gren-lang"}.integrity;
        };
        postject = pkgs.fetchurl {
          url = pkgLock.packages.${"node_modules/postject"}.resolved;
          hash = pkgLock.packages.${"node_modules/postject"}.integrity;
        };
        commander = pkgs.fetchurl {
          url = pkgLock.packages.${"node_modules/commander"}.resolved;
          hash = pkgLock.packages.${"node_modules/commander"}.integrity;
        };
      in
        pkgs.stdenv.mkDerivation {
          src = ./.;
          pname = "gren";
          version = pkgJson.dependencies.${"gren-lang"};
          buildInputs = [pkgs.${nodePkg}];
          buildPhase = ''
            export HOME=$PWD/.home
            export npm_config_cache=$PWD/.npm
            mkdir -p $out/js
            cd $out/js
            cp -r $src/. .
            npm cache add "${gren}"
            npm cache add "${postject}"
            npm cache add "${commander}"
            npm ci
          '';
          installPhase = ''
            ln -s $out/js/node_modules/.bin $out/bin
          '';
        };
    });
  };
}
