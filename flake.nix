# inspired by https://www.nmattia.com/posts/2022-12-18-lockfile-trick-package-npm-project-with-nix/
{
  description = "The Gren programming language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    systems,
    nixpkgs,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    nodePkg = "nodejs_20";
  in {
    devShells = eachSystem (system: {
      default = with import nixpkgs {inherit system;};
        mkShell {
          buildInputs = [
            pkgs.${nodePkg}
          ];
        };
    });
    packages = eachSystem (system: {
      default = with import nixpkgs {inherit system;}; let
        # Download all packages that end up in node_modules so they can be
        # pulled from cache in the build phase when we are sandboxed.
        gren = builtins.fetchTree {
          type = "github";
          owner = "gren-lang";
          repo = "compiler";
          rev = "1d6464ca679893422ee9976cdbed8123508cfffc";
        };
        pkgJson = builtins.fromJSON (builtins.readFile "${gren.outPath}/package.json");
      in
        pkgs.stdenv.mkDerivation {
          src = gren.outPath;
          pname = "gren";
          version = pkgJson.version;
          buildInputs = [pkgs.${nodePkg}];
          buildPhase = ''
            mkdir -p $out/bin
          '';
          installPhase = ''
            cp $src/bin/compiler $out/bin/gren
          '';
        };
    });
  };
}
