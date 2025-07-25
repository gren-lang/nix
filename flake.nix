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
          rev = "e2c4ff814a043f02fb9e55ab09e681ff78dc10e3";
        };

        pkgJson = builtins.fromJSON (builtins.readFile "${gren.outPath}/package.json");
      in
        pkgs.stdenv.mkDerivation {
          src = ./.;
          pname = "gren";
          version = pkgJson.version;
          buildInputs = [pkgs.${nodePkg}];
          buildPhase = ''
            mkdir -p $out/bin
            mkdir -p $out/libexec/gren

            cat ${gren.outPath}/bin/compiler | node ./prep.js > compiler.prepped.js
            node --snapshot-blob $out/libexec/gren/compiler.snapshot.js --build-snapshot compiler.prepped.js
          '';
          installPhase = ''
            cat <<EOF > "$out/bin/gren"
            #!/usr/bin/env bash
            # ${pkgs.git}
            ${pkgs.${nodePkg}}/bin/node --snapshot-blob $out/libexec/gren/compiler.snapshot.js
            EOF

            chmod +x "$out/bin/gren"
          '';
        };
    });
  };
}
