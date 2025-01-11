# Gren Nix Package

Use [Gren](https://gren-lang.org/) via nix.

You can use `github:gren-lang/nix` most places you'd use a package name or URL.
For example:

* [devbox](https://www.jetify.com/devbox): `devbox add github:gren-lang/nix`
* nix shell: `nix shell github:gren-lang/nix`

You can point to a specific ref (commit, tag, branch) like this:

* `github:gren-lang/nix/main`
* `github:gren-lang/nix/0.4.5`

## Bumping the gren version in this repo

* Start a dev shell: `nix develop`
* Update version in [`package.json`](/package.json)
* Update package lock file: `npm install`
* NOTE: if there was anything added or removed from the dependencies in `package-lock.json` you will need to update `flake.nix` to add them to the npm cache. TODO: automate this.
* Update flake lock file: `nix flake update`
* Test with `nix build .#` which should build an executable at `./result/bin/gren`
* Commit the updated `package.json`, `package-lock.json` and `flake.lock` files
* `git tag -a [version]`
* `git push origin main --tags`
* Test with `nix shell github:gren-lang/nix/[version]
