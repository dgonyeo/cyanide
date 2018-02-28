# Cyanide: home bar management system

## What is cyanide?

Cyanide is an ncurses-style console application that tracks and manages
ingredients and recipes for a home bar. It can track current inventory and past
purchases for ingredients, show you what recipes you can make with your current
inventory, and filter recipes by spirit type, glass, and a search string.

![Screenshot of the homepage](screenshots/2018-02-22_20:22:45_3200x1800_scrot.png)

## Acquiring cyanide

### Binaries

Cyanide can be downloaded from the [releases page on GitHub][releases]:

```
curl -o cyanide https://github.com/dgonyeo/cyanide/...
chmod +x cyanide
```

Cyanide can also be built from source with [stack][stack]. Note that you'll need
to either modify `stack.yaml` or have a working [nix][nix] install to build
cyanide.

```
git clone https://github.com/dgonyeo/cyanide
cd cyanide
stack install
```

### Docker images



## Running cyanide

Cyanide was developed, tested, and is actively used on Linux. It's possible it
will run without issue on MacOS or Windows, but this hasn't been attempted.

Running concurrent copies of cyanide is not recommended. It could be fine, but
if data is being modified the changes may not appear across all instances.

### Configuration

Cyanide can be configured via a configuration file stored at
`~/.config/cyanide/cyanide.conf`. If this file doesn't exist when cyanide is
run, the user will be asked if cyanide should create the file. If yes, the
default contents are:

```
[DATABASE]
host = localhost
port = 5432
user = cyanide
password = cyanide
database = cyanide

[EDITOR]
editor =
```

This file can be edited to alter the database configuration, and change the
editor. If the editor is unset, the `$EDITOR` environment variable is used, and
if that is also unset then `vim` is used. The editor is used for modifying
recipe instructions, and it's recommended to configure the editor to enable
spell checking.

## Recipe database

Entering in recipes by hand is very tedious, and ideally cyanide would ship with
a set of default recipes. Unfortunately until permissions to republish recipes
are acquired or a public domain data set is found, such a recipe list cannot be
freely distributed.

## License

GPLv3

[releases]: https://github.com/dgonyeo/cyanide/releases
[stack]: https://docs.haskellstack.org/en/stable/README/
[nix]: https://nixos.org/nix/
