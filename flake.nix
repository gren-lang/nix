{
  description = "The Gren programming language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, systems, nixpkgs }:
    let
      src = ./.;
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      pkgJson = builtins.fromJSON (builtins.readFile (src + "/package.json"));
    in {
    packages = eachSystem (system: {
      default = 
        with import nixpkgs { system = system; };
        pkgs.stdenv.mkDerivation {
          inherit src;
          name = "gren";
          version = pkgJson.dependencies.${"gren-lang"};
          buildInputs = [ pkgs.nodejs_20 ];
          buildPhase = "mkdir -p $out/bin";
          installPhase = ''
            ln -s $src/node_modules/gren-lang/index.js $out/bin/gren
          '';
        };
    });
  };
}
