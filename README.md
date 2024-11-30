# Gren Nix Package

Use [Gren](https://gren-lang.org/) via nix.

You can use `github:gren-lang/nix` most places you'd use a package name or URL.
For example:

* [devbox](https://www.jetify.com/devbox): `devbox add github:gren-lang/nix`
* nix shell: `nix shell github:gren-lang/nix`

You can point to a specific ref (commit, tag, branch) like this:

* `github:gren-lang/nix/main`
* `github:gren-lang/nix/0.4.5`

## Bumping the gren version

* update version in [`package.json`](/package.json)
* Start a dev shell: `nix develop`
* Update package lock file: `npm install`
* Update flake lock file: `nix flake update`
* test with `nix build .#` which should build an executable at `./result/bin/gren`
* commit the updated `package.json`, `package-lock.json` and `flake.lock` files
* `git tag -a [version number]`
* `git push --tags origin main`
