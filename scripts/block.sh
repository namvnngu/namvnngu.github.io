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

# nullglob prevents glob patterns from remaining unexpanded when they don't
# match anything. If no files match, the pattern expands to nothing, and
# the loop is skipped safely.
shopt -s nullglob

for target in "$SRC_PATH"/*.html "$SRC_PATH"/*/*.html "$SRC_PATH"/*/*/*.html; do
  start_line_numbers=()
  while read -r line_number; do
    start_line_numbers+=("$line_number")
  done < <(sed -n "/<!-- block-start: $block -->/=" "$target")

  end_line_numbers=()
  while read -r line_number; do
    end_line_numbers+=("$line_number")
  done < <(sed -n "/<!-- block-end: $block -->/=" "$target")

  if [[ "${#start_line_numbers[@]}" -ne "${#end_line_numbers[@]}" ]]; then
    echo "$target: '$block' mismatched number of start/end block tags"
    exit 1
  fi

  for index in "${!start_line_numbers[@]}"; do
    start_line_numbers=()
    while read -r line_number; do
      start_line_numbers+=("$line_number")
    done < <(sed -n "/<!-- block-start: $block -->/=" "$target")

    end_line_numbers=()
    while read -r line_number; do
      end_line_numbers+=("$line_number")
    done < <(sed -n "/<!-- block-end: $block -->/=" "$target")

    if [[ "${#start_line_numbers[@]}" -ne "${#end_line_numbers[@]}" ]]; then
      echo "$target: '$block' mismatched number of start/end block tags"
      exit 1
    fi

    start_line_number="${start_line_numbers[index]}"
    end_line_number="${end_line_numbers[index]}"

    if [[ -z "$start_line_number" || -z "$end_line_number" ]]; then
      continue
    fi

    if [[ "$start_line_number" -gt "$end_line_number" ]]; then
      echo "$target: '$block' start line ($start_line_number) after end line ($end_line_number)"
      continue
    fi

    if [[ "$start_line_number" -eq "$end_line_number" ]]; then
      echo "$target: '$block' start and end tags on same line ($start_line_number)"
      continue
    fi

    if [[ "$((start_line_number + 1))" -eq  "$end_line_number" ]]; then
      sed -i "" -e "${start_line_number}r $block_path" "$target"
      echo "$target: '$block' inserted after line $start_line_number"
      continue
    fi

    sed -i "" \
      -e "$((start_line_number + 1)),$((end_line_number - 1))d" \
      -e "${start_line_number}r $block_path" \
      "$target"
    echo "$target: '$block' updated between lines $start_line_number and $end_line_number"
  done
done
