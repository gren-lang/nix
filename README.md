# Gren Nix Package

Use [Gren](https://gren-lang.org/) via nix.

You can use `github:blaix/nix-gren` most places you'd use a package name or URL.
For example:

* [devbox](https://www.jetify.com/devbox): `devbox add github:blaix/nix-gren`
* nix shell: `nix shell github:blaix/nix-gren`

You can point to a specific ref (commit, tag, branch) like this:

* `github:blaix/nix-gren/main`
* `github:blaix/nix-gren/0.4.5`

## Bumping the gren version

* update version in [`package.json`](/package.json)
* Start a dev shell: `nix shell`
* Update package lock file: `npm install`
* Update flake lock file: `nix flake update`
* test with `nix build .#` which should build an executable at `./result/bin/gren`
* commit the updated `package.json`, `package-lock.json` and `flake.lock` files
* `git tag -a [version number]`
* `git push --tags origin main`
