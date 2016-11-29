# dctk: organize your programs with *[Dawson's Creek Trapper Keeper Ultra Keeper Futura S 2000]*

dctk helps you set up your own command or commands, which use separate
scripts as subcommands.  Such commands work much like `git` or `rbenv`.

Subcommands are scripts or programs, independent of one another and
dealing with individual concerns.

Think of it as a way to organize a large amount of functionality into a
single command, like pages in a sort of trapper-keeper, to keep the joke
going.

# examples

Here are some quick examples in the model of rbenv, if rbenv were
implemented as a trapper-keeper:

    $ rbenv                    # prints out usage and lists available subcommands
    $ rbenv versions           # runs the "versions" subcommand
    $ rbenv shell 1.9.3-p194   # runs the "shell" subcommand, passing "1.9.3-p194" as an argument

Each subcommand maps to a separate, standalone executable file. dctk
operates with the following basic tree structure (all are directories):

    .
    ├── bin               # your command's link to the dctk executable
    ├─┬ dctk              # built-in functionality
    │ └── …
    ├── completions       # autocompletion for your command
    ├── [command]         # your command's subcommands
    └── …

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

    eval "$("$HOME"/[path to your dctk]/bin/[command] init -)"

Finally, you may decide to get rid of the `.git` folder and start your
own repository.

Once `prepare`d, dctk becomes the new command is invoked like so:

    $ [command] [subcommand] [(args)]

# the dctk command

Your command in `bin` is actually a link to the dctk script in
`dctk/bin/dctk`.  You can examine the file there to see the guts of dctk
in action.

dctk determines your command name from how it was invoked on the
command-line, so the fact that its filename doesn't match the command is
not important.

From here on out, when this document refers to the `dctk` command, it
means your command instead, once you've `prepare`d the project.  To be
clear, once `prepare`d, there is no `dctk` command.

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
`bin`, `dctk`, `completions` or `shpec`.  Anything else is fair game.

Subcommands don't have to be written in bash.  They can be any
executable, scripted or compiled.  Even symlinks work.

Subcommands can provide documentation in comments, automatically made
available through the `dctk` and `dctk help [subcommand]` commands.

Subcommands can also provide shell autocompletion by implementing a
well-known flag (`--complete`).  dctk handles the details of informing
the shell (bash and zsh supported).

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
comment, like so:

    # provide completions

Your script must also parse the flag `--complete`.  Here's a made-up
example from rbenv:

``` bash
#!/usr/bin/env bash

# Provide rbenv completions
if [[ $1 == "--complete" ]]; then
  echo --path
  exec rbenv shims --short
fi

# etc...
```

Passing the `--complete` flag to this subcommand should short circuit
its normal operation and instead echo the list of valid completions.
dctk feeds this to your shell's autocompletion handler for you.

# multiple commands

When you saw the directory tree earlier, it was for a single command.
However you can have multiple commands as well, each independent of the
other.

    .
    ├── bin               # your commands' links to the dctk executable
    ├── completions       # your commands' links to the completions script
    ├── …
    ├── [command]         # one command's subcommands
    ├── [another command] # you can have more than one
    └── …

Each command exists side-by-side in its own directory.  Each has its own
subcommands.

All that is required to become a command is for the directory to exist,
and for there to be link with the command's name to the dctk executable:

    $ mkdir [command]
    $ cd bin
    $ ln -sf ../dctk/bin/dctk [command]

You should also enable completions for your command with a link:

    $ cd ../completions
    $ ln -sf ../dctk/completions/dctk.bash [command].bash   # or .zsh, if that's your shell

Add subcommands to the [command] directory and you're good to go.

# complex and legacy commands

So far, you've seen simple commands.  Subcommands exist simply as
executables in their command's directory.

However, your subcommands may require more structure.  For example, you
may have data files which might go in `[command]/share`.

Or you may have a command which is already a project of its own, such as
an existing [sub] or a repo you'd like to add as a git submodule.

    .
    ├── …
    ├─┬ [complex command] # when you already have or need more structure
    │ ├── bin             # if bin and/or libexec exist, look there instead for subcommands
    │ ├── libexec         # for example, when importing an existing project or [sub]
    │ ├── share           # or to separate out supporting files
    │ └── other           # whatever you like
    └── …

If dctk sees a `[command]/bin` and/or `[command]/libexec` directory, it
will treat the command as complex.  A complex command finds its
subcommands in the `bin` and `libexec` subdirectories instead of the
main `[command]` directory.  This allows you to have commands with more
structure, or to use legacy commands without having to adapt them.

# why "trapper-keeper"?

dctk is meant to make it easy to assimilate any kind of technology into
your trapper-keeper as a subcommand, much like *Dawson's Creek Trapper
Keeper Ultra Keeper Futura S 2000* assimilated all of Cartman's
belongings (as well as Cartman himself).  His trapper-keeper ultimately
became sentient and took over the world.  Hopefully yours will be less
ambitious, while still as powerful.

# isn't dctk just a rip-off of [sub]?

dctk is inspired by sub but shares very little code with it, having been
significantly rewritten.  It also sports a number of new features:

  - multiple top-level commands in one trapper-keeper

Future:

  - hierarchical subcommands by nesting directories

  - simple integration of legacy commands

  - functions as subcommands

  - [docopt] support

# License

Apache 2.0. See `LICENSE.md`.

[Dawson's Creek Trapper Keeper Ultra Keeper Futura S 2000]: https://en.wikipedia.org/wiki/Trapper_Keeper_(South_Park)
[sub]:    https://github.com/basecamp/sub
[docopt]: http://docopt.org/
