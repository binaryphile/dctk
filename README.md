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
operates with the following basic tree structure (all are directories):

    .
    ├── bin               # link(s) to main dctk executable, but named after their [command](s)
    ├─┬ dctk              # built-in functionality
    │ ├── libexec         # core dctk command and subcommands
    │ └── completions     # bash/zsh automatic completion code
    ├── [command]         # your command's subcommands
    ├── [another command] # you can have more than one
    └─┬ [legacy command]  # when you already have or need more structure
      ├── bin             # if bin and/or libexec exist, look there instead for subcommands
      ├── libexec         # for example, when importing an existing project or [sub]
      ├── share           # or to separate out supporting files
      └── other           # whatever you like

# creating your first command

Here's an example of adding a new subcommand. Let's say your
trapper-keeper is named "rush". Run:

    touch rush/who
    chmod +x rush/who

Edit `rush/who` with the following:

``` bash
#!/usr/bin/env bash

who
```

Now you can run `rush who`:

    $ rush who
    qrush     console  Sep 14 17:15

That's it.  You now have a working subcommand.

You can add autocompletion support and help documentation as well, by
adding a little bit more to your script, as you'll see.

# dctk the project versus the command

dctk, the project, is this repo and the code of which it is comprised.

While it is invoked using the command `dctk` at the moment, which is a
link in `bin`, the link will ultimately be renamed to your command's
name.  This readme refers to the project and how it works as dctk, even
though there won't be a `dctk` command after you `prepare` it.

Your project will contain dctk's bones but will add the functionality
that makes it your own command.

# installation

First clone this repository to your own command's name:

    $ git clone --depth=1 git://github.com/binaryphile/dctk [your command name]

Then run the `prepare` script while in this directory:

    $ cd [command]
    $ ./prepare [command]

Third, add the following to your shell's startup script (.bash_profile
or .zshrc, for example):

    eval "$("$HOME"/[path to command]/bin/[command] init -)"

Finally, you may decide to get rid of the `.git` folder and start your
own repository.

Once `prepare`d, dctk becomes the new command is invoked like so:

    $ [command] [subcommand] [(args)]

# the dctk command

Your command in `bin` is actually a link to the dctk script in
`dctk/dctk`.  You can examine the file their to see the guts of dctk in
action.

dctk determines your command name from how it was invoked on the
command-line, so the fact that its filename doesn't match the command is
not important.

When this document refers to the `dctk` command, it means your command
instead once you've `prepare`d the project.  Once `prepare`d, there is no
`dctk` command.

# what's in your trapper-keeper

Your trapper-keeper comes with a few basics built-in:

  - `dctk commands` - Print available subcommands

  - `dctk completions` - Provide command completion details for use by shell
    autocompletion

  - `dctk help` - Parse and display subcommand help, if provided in the
    script

  - `dctk init` - Hook completions into the shell, usually when invoked from
    a shell startup file (e.g. `.bash_profile`)

If you ever need to reference files inside of your trapper-keeper
installation, say to access a file in the `share` directory, your
trapper-keeper makes the location of its root directory available in the
environment variable `_[COMMAND]_ROOT`.  For example, if your command is
named "rush", then the variable is `_RUSH_ROOT`.

# subcommands

Subcommands live in the directory named for your command and are simply
named for the subcommand, e.g. `rbenv/versions`.  For this reason you
can't make a command with the same name as the existing directories,
`bin` or `dctk`.  Anything else is fair game.

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

# why a trapper-keeper?

dctk is meant to make it easy to assimilate any kind of technology into
your trapper-keeper as a subcommand, much like *Dawson's Creek Trapper
Keeper Ultra Keeper Futura S 2000* assimilated all of Cartman's
belongings (as well as Cartman himself).  The trapper-keeper ultimately
became sentient and took over the world.  Hopefully yours is less
ambitious, while still as powerful.

# Isn't dctk just a rip-off of [sub]?

dctk is inspired by sub but is rewritten from the ground up and adds
significant new features:

  - easier integration of existing projects as subcommands

Future:

  - hierarchical subcommands which can be nested in directories

  - support for multiple top-level commands in one trapper-keeper

  - task functions within scripts which are subcommands of their own,
    with first-class support like other subcommands

  - docopt support

# License

Apache 2.0. See `LICENSE.md`.

Because this is a ground-up rewrite of [sub], it does not contain the
code of the sub project and is licensed under the Apache license rather
than that project's MIT license.

[Dawson's Creek Trapper Keeper Ultra Keeper Futura S 2000]: https://en.wikipedia.org/wiki/Trapper_Keeper_(South_Park)
[sub]:                                                      https://github.com/basecamp/sub
