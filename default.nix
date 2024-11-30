let
  pkgs = import <nixpkgs> {};
  src = ./.;
  packageJson = builtins.fromJSON (builtins.readFile (src + "/package.json"));
in
pkgs.stdenv.mkDerivation {
  inherit (packageJson.dependencies) "gren-lang";
  inherit src;
  name = "gren";
  buildInputs = [ pkgs.nodejs_20 ];
  buildPhase = ''
    mkdir -p $out/bin
  '';

  installPhase = ''
    ln -s $src/node_modules/gren-lang/index.js $out/bin/gren
  '';
}
