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
commands and [fzf](https://github.com/junegunn/fzf).

## Build a simple command manager

### Prerequisites

- [bash](https://www.gnu.org/software/bash)
- [fzf](https://github.com/junegunn/fzf)
- [sed](https://www.gnu.org/software/sed)
- [grep](https://www.gnu.org/software/grep)

### Project structure

### Command files

### Find command with `fzf`

### Detect placeholders and fill in values

### Execute command

### Full implementation

## Final words

Hope you enjoy it. Take care.

Nam Nguyen
