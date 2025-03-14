#!/usr/bin/env bash

SRC_PATH=./src
BLOCKS_PATH=./src/blocks

block=$1
block=$(basename "$block")
block=${block%.*}
block_path="$BLOCKS_PATH/$block.html"

if [[ ! -f "$block_path" ]]; then
  echo "$block_path: file not found"
  exit 1
fi

for target in "$SRC_PATH"/*.html "$SRC_PATH"/**/*.html
do
  if [[ "$target" == "$BLOCKS_PATH"* ]]; then
    continue
  fi

  start_line_number=$(sed -n "/<!--block-start: $block-->/=" $target)
  end_line_number=$(sed -n "/<!--block-end: $block-->/=" $target)

  if [[ -z "$start_line_number" || -z "$end_line_number" ]]; then
    echo "$target: '$block' block not found"
    continue
  fi

  if [[ "$start_line_number" == "$end_line_number" ]]; then
    echo "$target: '$block' block start and block end on the same line $start_line_number"
    continue
  fi

  if [[ "$((start_line_number + 1))" == "$end_line_number" ]]; then
    sed -i "" -e "${start_line_number}r $block_path" "$target"
    echo "$target: '$block' updated"
    continue
  fi

  sed -i "" \
    -e "$((start_line_number + 1)),$((end_line_number - 1))d" \
    -e "${start_line_number}r $block_path" \
    "$target"
  echo "$target: '$block' updated"
done
