---
title: How Do I Save Terminal Commands?
lang: en
...

Published on April 24, 2025.

## Motivation

I often find myself in a situation where I want to remember a useful terminal
command, but I have a poor memory and tend to forget it after just a few days.
I used to save all the useful commands in [Obsidian](https://obsidian.md), which
I use daily as my second brain for notes, planning, learning, and more.

However, whenever I need to use a command I previously bumped into and saved in
the note, it is a bit tedious to jump out of terminal, open Obsidian, search for
the note and find the right command. On top of that, I sometimes include
placeholders for command options whose values are dynamic case by case, so
whenever I need to use such a command with options, I have to copy it from the
note, paste it into the terminal, and then manually fill in the appropriate
values.

Therefore, I want to build a command manager that I can use directly within the
terminal. It can detect option placeholders in a saved command and prompt me to
fill values in. It should be built with my existing daily tools namely built-in
commands on macOS/Linux and [fzf](https://github.com/junegunn/fzf).

## Build a simple command manager

The command manager is named `cmd`. A note that `cmd` supports macOS and Linux
only.

### Prerequisites

- `bash`
- [fzf](https://github.com/junegunn/fzf)
- Built-in commands such as `sed`, `grep`, `cat`, `find`, `tr`, `uname` and
`pbcopy` on macOS or `xclip` on Linux.

### Features

Before jumping into building the command, it is helpful to define the list of
features first:

- Save commands in `cmd-*` files (e.g. `cmd-git`), where `*` is a category.
- Accept either zero or one argument; if provided, the argument should be a
category.
- If no argument is given, list all saved commands across all categories.
- If a category as an argument is given, list only the commands of that
category.
- Allow to select one command at a time.
- If the selected command has placeholders, prompt to fill them in.
- After a command is selected and placeholders are filled, there are two
options: copy or execute. If neither option is selected, continue prompting
until one option is chosen.

### Project structure

Files
``` {.numberLines}
.
├── cmd
└── cmd-git
├── cmd-find
```

- `cmd` is the command manager.
- `cmd-*` (e.g. `cmd-find` and `cmd-git`) files consist of saved commands along
with brief descriptions, where `*` is a category. The content of these files
will be explained in detail below.

### Command files

cmd-git
``` {.numberLines}
git log oneline in graph: git log --oneline --graph
git rename current branch: git branch -m <new-name>
```

Let's break down the above file:

### Find command with `fzf`

cmd
```bash {.numberLines}
#!/usr/bin/env bash
```

### Detect placeholders and fill in values

### Execute command

### Full implementation

cmd
```bash {.numberLines}
#!/usr/bin/env bash
```

Or, you can find [my full implementation](https://github.com/namvnngu/.dotfiles/blob/main/bin/cmd)
that I use in my daily development.

## Final words

Hope you enjoy it. Take care.

Nam Nguyen
