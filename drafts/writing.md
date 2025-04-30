---
title: How Do I Save Terminal Commands?
lang: en
...

Published on April 30, 2025.

## Motivation

I often find myself in a situation where I want to remember a useful terminal
command, but I have a poor memory and will forget it after a few days. I used
to save all useful commands in [Obsidian](https://obsidian.md), which I use
daily as my second brain for notes, planning, learning, and more.

However, whenever I need to use a command I previously bumped into and saved in
the note, it is a bit tedious to jump out of the terminal, open Obsidian, search
for the note and find the right command. On top of that, I sometimes include
placeholders for command arguments which are dynamic case by case, so whenever
I need to use such a command with placeholders, I have to copy it from the note,
paste it into the terminal, and then manually fill in the appropriate values.

Therefore, I want to build a command manager that I can use directly within the
terminal. It can detect placeholders in a saved command and prompt me to fill
values in. It should be built with my existing daily tools namely built-in
commands on macOS/Linux and [fzf](https://github.com/junegunn/fzf).

## Build a simple command manager

Before we start, if you are not yet familiar with Bash, I highly recommend
checking out [Learn Bash in Y minutes](https://learnxinyminutes.com/bash) or
[Bash scripting cheatsheet](https://devhints.io/bash) for a brief introduction.

The command manager is named `cmd`. A note that `cmd` supports macOS and Linux
only.

### Prerequisites

- `bash`
- [fzf](https://github.com/junegunn/fzf)
- Built-in commands such as `sed`, `grep`, `cat`, `find`, `tr`, `uname` and
`pbcopy` on macOS or `xclip` on Linux.

### Features

Before we jump into building the command, it is helpful to define the list of
features first:

- Save commands in `cmd-*` categories files, where `*` is a category, e.g.
`cmd-git` where `git` is a category.
- Accept either zero or one argument; if provided, the argument should be a
category.
- If no argument is given, list all saved commands across all category files.
- If a category as an argument is given, list only saved commands in the
corresponding category file.
- Allow to select only one command at a time.
- If the selected command has placeholders, prompt to fill them with input
values.
- After a command is selected and placeholders are filled, there are three
actions: copy, execute and quit. If neither action is selected, continue
prompting until one action is chosen.

### Project structure

Files
``` {.numberLines}
.
├── cmd
├── cmd-find
└── cmd-git
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
contain `<placeholder>`s.

The content of the `cmd-git` file looks like this:

cmd-git
``` {.numberLines}
git log oneline in graph: git log --oneline --graph
git rename current branch: git branch -m <new-name>
git go back n commit(s) from HEAD: git reset --<mode> HEAD~<n>
```

Let's break down the `cmd-git` file above:

- The first entry: `git log oneline in graph: git log --oneline --graph`
  - `git log oneline in graph` is a description.
  - `git log --oneline --graph` is a command with no placeholders.
- The second entry: `git rename current branch: git branch -m <new-name>`
  - `git rename current branch` is a description.
  - `git branch -m <new-name>` is a command with a `<new-name>` placeholder.
- The third entry: `git go back n commit(s) from HEAD: git reset --<mode> HEAD~<n>`
  - `git go back n commit(s) from HEAD` is a description.
  - `git reset --<mode> HEAD~<n>` is a command with two placeholders, `<mode>`
  and `<n>`.

Then, let's add one command entry to the `cmd-find` file:

cmd-find
``` {.numberLines}
find and delete empty directories: find <target-path> -type d -empty -delete
```

Now, let's build the command manager in Bash in the below sections. I will use
in-line comments to explain what each line is.

I have a tip. If you do not understand what a command is and what their flags or
options are, you can run the `man` command with a command name to read its
manual. For example, if I want to read `grep` manual, I can run the below
command:

``` bash {.numberLines}
man grep
```

### Find command with `fzf`

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

# The optional category passed as an argument
category="$1"

# The directory of all command files
cmd_dir="."

# The path to the command file based on the category
cmd_file="$cmd_dir/cmd-$category"

# The selected command based on the category
cmd=""

# === Find command with fzf ===

# If no argument is provided, i.e. no category
if [[ $# -eq 0 ]]; then
  # Find all command files whose name starts
  # with "cmd-" in the "cmd_dir" directory
  files=$(find "$cmd_dir" -maxdepth 1 -name "cmd-*")

  # Find a command entry across all found command files
  cmd=$(cat $files | fzf)
# If the command file exists based on the category
elif [[ -e "$cmd_file" ]]; then
  # Find a command entry within the command file
  cmd=$(cat "$cmd_file" | fzf)
# If the command file is not found based on the category
else
  # Print the not found error message
  echo "$cmd_file: No such file"

  # Exit with the error code
  exit 1
fi

# If the "cmd" variable is empty,
# i.e. no command entry is selected
if [[ -z "$cmd" ]]; then
  # Exit with the success code
  exit 0
fi

# Remove the "description: " part to get
# the command from the selected command entry
cmd=$(echo "$cmd" | sed "s/^.*: //")

# Print the selected command
echo "Selected command: $cmd"
```

### Detect placeholders and fill in values

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

...

# The selected command based on the category
cmd=""

# === Find command with fzf ===
...

# === Detect placeholders and fill in values ===

# Get all placeholders in the selected command
placeholders=$(echo "$cmd" | grep -oE "<(\w|-)+>")

# If the "placeholders" variable is not empty,
# i.e. there is at least one placeholder
if [[ -n "$placeholders" ]]; then
  echo "----------------------"

  # Loop through each placeholder
  for k in $placeholders; do
    # Prompt to input a value for the placeholder
    read -p "$k: " v

    # Replace the placeholder in the selected command
    # with the input value
    cmd=$(echo "$cmd" | sed "s/$k/$v/g")

    # Print the updated command after the replacement
    echo "Command: $cmd"
  done

  echo "----------------------"
fi
```

### Perform action on command

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

...

# The selected command based on the category
cmd=""

# === Find command with fzf ===
...

# === Detect placeholders and fill in values ===
...

# === Perform action on command ===

# Keep prompting until a valid action is chosen
while true; do
  # Prompt to input a value for the action
  read -p "copy (c), execute (e) or quit (q)? " action

  # Transform the input value to lowercase
  # for easier matching
  action=$(echo "$action" | tr "[:upper:]" "[:lower:]")

  # If the selected action is to copy
  if [[ "$action" == c* ]]; then
    # Get the operating system
    os=$(uname -s)

    case "$os" in
      # If OS is macOS
      Darwin*)
        # Copy the selected command to clipboard
        echo -n "$cmd" | pbcopy
        ;;
      # If OS is Linux
      Linux*)
        # Copy the selected command to clipboard
        echo -n "$cmd" | xclip -selection clipboard
        ;;
    esac

    # Print a message that the selected command
    # has been copied
    echo "Copied to clipboard: $cmd"

    # Exit with the success code
    exit 0
  # If the selected action is to execute
  elif [[ "$action" == e* ]]; then
    # Print a message that the selected command
    # is being executed
    echo "Executing: $cmd"

    # Execute the selected command
    eval "$cmd"

    # Exit with the success code
    exit 0
  # If the selected action is to quit
  elif [[ "$action" == q* ]]; then
    # Exit with the success code
    exit 0
  else
    # Print a warning message to enter a valid action
    echo "Only copy (c), execute (e) or quit (q)?"
  fi
done
```

### Full implementation

cmd
``` bash {.numberLines}
#!/usr/bin/env bash

# The optional category passed as an argument
category="$1"

# The directory of all command files
cmd_dir="."

# The path to the command file based on the category
cmd_file="$cmd_dir/cmd-$category"

# The selected command based on the category
cmd=""

# === Find command with fzf ===

# If no argument is provided, i.e. no category
if [[ $# -eq 0 ]]; then
  # Find all command files whose name starts
  # with "cmd-" in the "cmd_dir" directory
  files=$(find "$cmd_dir" -maxdepth 1 -name "cmd-*")

  # Find a command entry across all found command files
  cmd=$(cat $files | fzf)
# If the command file exists based on the category
elif [[ -e "$cmd_file" ]]; then
  # Find a command entry within the command file
  cmd=$(cat "$cmd_file" | fzf)
# If the command file is not found based on the category
else
  # Print the not found error message
  echo "$cmd_file: No such file"

  # Exit with the error code
  exit 1
fi

# If the "cmd" variable is empty,
# i.e. no command entry is selected
if [[ -z "$cmd" ]]; then
  # Exit with the success code
  exit 0
fi

# Remove the "description: " part to get
# the command from the selected command entry
cmd=$(echo "$cmd" | sed "s/^.*: //")

# Print the selected command
echo "Selected command: $cmd"

# === Detect placeholders and fill in values ===

# Get all placeholders in the selected command
placeholders=$(echo "$cmd" | grep -oE "<(\w|-)+>")

# If the "placeholders" variable is not empty,
# i.e. there is at least one placeholder
if [[ -n "$placeholders" ]]; then
  echo "----------------------"

  # Loop through each placeholder
  for k in $placeholders; do
    # Prompt to input a value for the placeholder
    read -p "$k: " v

    # Replace the placeholder in the selected command
    # with the input value
    cmd=$(echo "$cmd" | sed "s/$k/$v/g")

    # Print the updated command after the replacement
    echo "Command: $cmd"
  done

  echo "----------------------"
fi

# === Perform action on command ===

# Keep prompting until a valid action is chosen
while true; do
  # Prompt to input a value for the action
  read -p "copy (c), execute (e) or quit (q)? " action

  # Transform the input value to lowercase
  # for easier matching
  action=$(echo "$action" | tr "[:upper:]" "[:lower:]")

  # If the selected action is to copy
  if [[ "$action" == c* ]]; then
    # Get the operating system
    os=$(uname -s)

    case "$os" in
      # If OS is macOS
      Darwin*)
        # Copy the selected command to clipboard
        echo -n "$cmd" | pbcopy
        ;;
      # If OS is Linux
      Linux*)
        # Copy the selected command to clipboard
        echo -n "$cmd" | xclip -selection clipboard
        ;;
    esac

    # Print a message that the selected command
    # has been copied
    echo "Copied to clipboard: $cmd"

    # Exit with the success code
    exit 0
  # If the selected action is to execute
  elif [[ "$action" == e* ]]; then
    # Print a message that the selected command
    # is being executed
    echo "Executing: $cmd"

    # Execute the selected command
    eval "$cmd"

    # Exit with the success code
    exit 0
  # If the selected action is to quit
  elif [[ "$action" == q* ]]; then
    # Exit with the success code
    exit 0
  else
    # Print a warning message to enter a valid action
    echo "Only copy (c), execute (e) or quit (q)?"
  fi
done
```

Remember to run the below command to make `cmd` executable:

``` bash {.numberLines}
chmod +x ./cmd
```

Now run it with all categories:

``` bash {.numberLines}
./cmd
```

Or, run it with the `git` category:

``` bash {.numberLines}
./cmd git
```

To make the `cmd` command accessible from anywhere, you can either add the path
to the directory containing it to your `$PATH` environment variable,

.zshrc/.bashrc
``` bash {.numberLines}
export PATH="$PATH:path-to-directory-containing-cmd"
```

or move it along with the `cmd-*` files into a directory that is already
included in your `$PATH`.

## Final words

I hope you enjoy the process of building and learn something along the way. I
often build something simple using tools already available on my machine, if the
existing solutions are more complex than necessary for my needs. As a result, I
have a chance to learn something new while producing fairly-good-and-simple
tools to serve my daily tasks.

Nam Nguyen
