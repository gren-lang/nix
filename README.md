# Gren Nix Flake

Use [Gren](https://gren-lang.org/) via nix flakes.

You can use `github:gren-lang/nix` most places you'd use a package name or URL.
For example:

* [devbox](https://www.jetify.com/devbox): `devbox add github:gren-lang/nix`
* nix shell: `nix shell github:gren-lang/nix`

You can point to a specific ref (commit, tag, branch) like this:

* `github:gren-lang/nix/main`
* `github:gren-lang/nix/0.4.5`

## Bumping the gren version in this repo

* Start a dev shell: `nix develop`
* Update the `rev` field in `flake.nix` to the full commit hash you wish to build
* Update flake lock file: `nix flake update` (this may or may not update `flake.lock`)
* Test with `nix build .#` which should build an executable you can test at `./result/bin/gren`
* Commit the updated `flake.nix` and `flake.lock` files
* `git tag -a [version]`
* `git push origin main --tags`
* Test with `nix shell github:gren-lang/nix/[version]`
