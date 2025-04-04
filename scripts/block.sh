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

for target in "$SRC_PATH"/*.html "$SRC_PATH"/**/*.html "$SRC_PATH"/**/**/*.html;
do
  if [[ "$target" == "$BLOCKS_PATH"* ]]; then
    continue
  fi

  start_line_numbers=($(sed -n "/<!--block-start: $block-->/=" $target | tr ' ' '\n'))
  end_line_numbers=($(sed -n "/<!--block-end: $block-->/=" $target | tr ' ' '\n'))

  if [[ "${#start_line_numbers[@]}" -ne "${#end_line_numbers[@]}" ]]; then
    echo "$target: '$block' the number of start block tags is not the same as the one of end block tags"
    exit 1
  fi

  indices=($(echo ${!start_line_numbers[@]} | tr ' ' '\n'))

  for index in "${indices[@]}";
  do
    start_line_numbers=($(sed -n "/<!--block-start: $block-->/=" $target | tr ' ' '\n'))
    end_line_numbers=($(sed -n "/<!--block-end: $block-->/=" $target | tr ' ' '\n'))

    if [[ "${#start_line_numbers[@]}" -ne "${#end_line_numbers[@]}" ]]; then
      echo "$target: '$block' the number of start block tags is not the same as the one of end block tags"
      continue
    fi

    start_line_number="${start_line_numbers[index]}"
    end_line_number="${end_line_numbers[index]}"

    if [[ -z "$start_line_number" || -z "$end_line_number" ]]; then
      continue
    fi

    if [[ "$start_line_number" -gt "$end_line_number" ]]; then
      echo "$target: '$block' the line number of the start block tag ($start_line_number) is greater than the one of the end block tag ($end_line_number)"
      continue
    fi

    if [[ "$start_line_number" -eq "$end_line_number" ]]; then
      echo "$target: '$block' the start block tag and the end block tag on the same line $start_line_number"
      continue
    fi

    if [[ "$((start_line_number + 1))" -eq  "$end_line_number" ]]; then
      sed -i "" -e "${start_line_number}r $block_path" "$target"
      echo "$target: '$block' updated at line $start_line_number"
      continue
    fi

    sed -i "" \
      -e "$((start_line_number + 1)),$((end_line_number - 1))d" \
      -e "${start_line_number}r $block_path" \
      "$target"
    echo "$target: '$block' updated at line $start_line_number"
  done
done
