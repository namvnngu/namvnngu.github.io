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
- If the selected command has placeholders, prompt to fill them with values.
- After a command is selected and placeholders are filled, there are three
options: copy, execute and quit. If neither option is selected, continue prompting
until one option is chosen.

### Project structure

Files
``` {.numberLines}
.
├── cmd
└── cmd-git
├── cmd-find
```

- `cmd` is the command manager written in `bash`.
- `cmd-*` (e.g. `cmd-find` and `cmd-git`) files consist of saved commands along
with brief descriptions, where `*` is a category. The content of these files
will be explained in detail below.

Remember to run the below command to make `cmd` executable:

``` bash {.numberLines}
chmod +x ./cmd
```

### Command files

In a command file, each line is one command entry. The format is

format
``` {.numberLines}
description: command
```

- `description` should be short and sweet.
- `command` is a command which will be copied or executed. It may optionally
contain placeholders.
  - Placeholders are written in a format `<placeholder>`.

For example, the content of a `cmd-git` file looks like this:

cmd-git
``` {.numberLines}
git log oneline in graph: git log --oneline --graph
git rename current branch: git branch -m <new-name>
```

Let's break down the above example:

- The first entry: `git log oneline in graph: git log --oneline --graph`
  - `git log oneline in graph` is a description.
  - `git log --oneline --graph` is a command with no placeholders.
- The second entry: `git rename current branch: git branch -m <new-name>`
  - `git rename current branch` is a description.
  - `git branch -m <new-name>` is a command with a `<new-name>` placeholder.

### Find command with `fzf`

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

# The optional category passed as an argument
category="$1"

# The directory of all command files
cmd_dir="."

# The path to the command file based on the given category
cmd_file="$cmd_dir/cmd-$category"

# The selected command based on the given category
selected_cmd=""

# === Find command with `fzf` ===

# If no argument is provided, i.e. no category
if [[ $# -eq 0 ]]; then
  # Find all command files whose prefix is "cmd-"
  files=$(find "$cmd_dir" -maxdepth 1 -name "cmd-*")
  # Find a command entry across all found command files
  selected_cmd_entry=$(cat $files | fzf)
# If a category is provided, and the command file exists
# based on the provided category
elif [[ -e "$cmd_file" ]]; then
  # Find a command entry within the specified command file
  selected_cmd_entry=$(cat "$cmd_file" | fzf)
# If the command file is not found based on
# the provided category
else
  # Print error message
  echo "$cmd_file: No such file"
  # Exit with error code
  exit 1
fi

# If no command entry is selected
if [[ -z "$selected_cmd_entry" ]]; then
  # Exit with success code
  exit 0
fi

# Remove "description: " part to get the actual command
# from the selected command entry
selected_cmd=$(echo "$selected_cmd_entry" | sed "s/^.*: //")
# Print the selected command
echo "Selected command: $selected_cmd"
```

### Detect placeholders and fill in values

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

...

# The selected command based on the given category
selected_cmd=""

# === Find command with fzf ===
...

# === Detect placeholders and fill in values ===
```

### Perform an action on command

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

...

# The selected command based on the given category
selected_cmd=""

# === Find command with fzf ===
...

# === Detect placeholders and fill in values ===
...

# === Perform an action on command ===
```

### Full implementation

cmd
``` bash {.numberLines}
#!/usr/bin/env bash
```

Or, you can find [my full implementation](https://github.com/namvnngu/.dotfiles/blob/main/bin/cmd)
that I use in my daily development.

## Final words

Hope you enjoy it. Take care.

Nam Nguyen
