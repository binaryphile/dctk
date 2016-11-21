# dctk: organize your programs with *[Dawson's Creek Trapper Keeper Ultra Keeper Futura S 2000]*

dctk is a basis for setting up your own shell programs to use
subcommands, much like `git` or `rbenv`.  Subcommands are scripts or
programs which are collected into your own personal command (we'll call
it a trapper-keeper, to keep the joke going), which is a way to organize
a large amount of functionality into a single command while preserving
the virtues of small, independent scripts dedicated to individual
concerns.

# examples

Here are some quick examples in the model of rbenv, if rbenv were
implemented as a trapper-keeper:

    $ rbenv                    # prints out usage and lists available subcommands
    $ rbenv versions           # runs the "versions" subcommand
    $ rbenv shell 1.9.3-p194   # runs the "shell" subcommand, passing "1.9.3-p194" as an argument

Each subcommand maps to a separate, standalone executable file. dctk
provides the following basic structure for you:

    .
    ├── bin               # your trapper-keeper's command-line executable(s)
    ├── completions       # optional bash/zsh completions
    ├── libexec           # subcommands executables
    └── share             # related platform-independent files

# creating your first command

Here's an example of adding a new subcommand. Let's say your
trapper-keeper is named `rush`. Run:

    touch libexec/rush-who
    chmod +x libexec/rush-who

Edit `rush-who` with the following:

``` bash
#!/usr/bin/env bash

who
```

Now you can run `rush who`:

    $ rush who
    qrush     console  Sep 14 17:15

That's it.  You now have a working subcommand.

You can add autocompletion support and help documentation as well, by
adding a little bit more to your script as you'll see.

# dctk the project versus the command

dctk, the project, is this repo and the code of which it is comprised.
While it is invoked using the command `dctk`, which lives in `libexec`,
that file will ultimately be renamed to your command's name.  I'll still
refer to the project and how it works as dctk, even though the `dctk`
file will no longer bear that name when you customize it.

Your project will contain dctk's bones but will add the functionality
that makes it your own command.

# installation

First clone this repository to your own command's name:

    $ git clone --depth=1 git://github.com/binaryphile/dctk [your command name]

Then run the `prepare` script while in this directory:

    $ cd [command]
    $ ./prepare [command]

Third, add the following to your shell's startup script:

    eval "$("$HOME"/[path to command]/bin/[command] init -)"

Finally, you may decide to get rid of the `.git` folder and perhaps
start your own repository.

Once renamed, dctk becomes the new command is invoked like so:

    $ [command] [subcommand] [(args)]

# the dctk command

dctk itself is renamed to your command.  The renamed script lives in
`libexec`.  You can examine that file to see the guts of dctk in action.

The dctk script might more correctly belong in `bin`, but for the
convenience of the renaming process it is in `libexec` with all of the
other basic scripts.  It is linked from `bin` however, and the minimum
for dctk to work (without autocompletion) is for `bin` to be on your
PATH (although you should use the eval statement in the installation
section instead for full support).

## what's in your trapper-keeper

Your trapper-keeper comes with a few basics built-in:

  - `[command] commands` - Print available subcommands

  - `[command] completions` - Provide command completion details for use by shell
    autocompletion

  - `[command] help` - Parse and display subcommand help, if provided in the
    script

  - `[command] init` - Hook completions into the shell, usually when invoked from
    a shell startup file (e.g. `.bashrc`)

If you ever need to reference files inside of your trapper-keeper
installation, say to access a file in the `share` directory, your
trapper-keeper makes the location of its root directory available in the
environment variable `_[COMMAND]_ROOT`.  For example, if your command is
named "rush", then the variable is `_RUSH_ROOT`.

# subcommands

Subcommands live in `libexec` and have names of the form
`[command]-[subcommand]`, where `[command]` is your new command name.

Subcommands don't have to be written in bash.  They can be any
executable, scripted or compiled.  Even symlinks work.

Subcommands can provide documentation in comments, automatically made
available through the `dctk` and `dctk help [subcommand]` commands.

Subcommands can also provide shell autocompletion via dctk by
implementing a well-known flag (`--complete`).  dctk handles the details
of informing the shell (bash and zsh supported).

Both of these features require the subcommand to be in a scripting
language which employs "#" as its comment delimiter.

# self-documenting subcommands

Documentation is provided by adding a few magic comments to your script.
This feature is limited to scripts which use "#" as their comment
delimiter.

Here's an example from `rush who` (also see `dctk commands` for another
example):

``` bash
#!/usr/bin/env bash
# Usage: rush who
# Summary: Check who's logged in
# Help: This will print out when you run `dctk help who`.
# You can have multiple lines even!
#
#    Show off an example indented
#
# And maybe start off another one?

who
```

Now, when you run `rush`, the "Summary" magic comment will now show up:

    usage: rush <command> [<args>]

    Some useful dctk commands are:
       commands               List all rush commands
       who                    Check who's logged in

And running `rush help who` will show the "Usage" magic comment, and
then the "Help" comment block:

    Usage: rush who

    This will print out when you run `rush help who`.
    You can have multiple lines even!

       Show off an example indented

    And maybe start off another one?

# autocompletion

dctk provides autocompletion at two levels:

  1. autocompletion of subcommand names (what subcommands are available
     in `libexec`?)

  2. opt-in autocompletion of potential arguments for your subcommands
     (what arguments does this subcommand take?)

Opting into autocompletion of subcommands requires that you add a magic
comment of (make sure to replace with your trapper-keeper's name!):

    # provide completions

Your script must also parse the flag `--complete`.  Here's an example
from rbenv, namely `rbenv whence`:

``` bash
#!/usr/bin/env bash

[[ -n $RBENV_DEBUG ]] && set -x

# Provide rbenv completions
if [[ $1 == "--complete" ]]; then
  echo --path
  exec rbenv shims --short
fi

# etc...
```

Passing the `--complete` flag to this subcommand short circuits its
normal operation and instead returns the valid completions to the shell.
dctk feeds this to your shell's autocompletion handler for you.

## why a trapper-keeper?

dctk is meant to make it easy to assimilate any kind of technology into
your trapper-keeper as a subcommand, much like *Dawson's Creek Trapper
Keeper Ultra Keeper Futura S 2000* assimilated all of Cartman's
belongings (as well as Cartman himself).  The trapper-keeper ultimately
became sentient and took over the world.  Hopefully yours is less
ambitious, while still as powerful.

## Isn't dctk just a rip-off of [sub]?

dctk is inspired by sub but is rewritten from the ground up and adds
significant new features:

Future:

  - hierarchical subcommands which can be nested in directories

  - easier integration of existing projects as subcommands

  - support for multiple top-level commands in one trapper-keeper

  - task functions within scripts which are subcommands of their own,
    with first-class support like other subcommands

  - docopt support

## License

Apache 2.0. See `LICENSE`.

Because this is a ground-up rewrite of [sub], it does not contain the
code of the sub project and is licensed under the Apache license rather
than that project's MIT license.

[Dawson's Creek Trapper Keeper Ultra Keeper Futura S 2000]: https://en.wikipedia.org/wiki/Trapper_Keeper_(South_Park)
[sub]:                                                      https://github.com/basecamp/sub
