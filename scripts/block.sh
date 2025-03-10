#!/usr/bin/env bash

start_line=$(sed -n '/block-start: footer/=' new.html)
end_line=$(sed -n '/block-end: footer/=' new.html)

if [[ -n "$start_line" && -n "$end_line" ]]; then
  sed -i "" \
      -e "$((start_line + 1)),$((end_line - 1))d" \
      -e "${start_line}r src/blocks/header.html" \
      new.html > out.html
else
  echo "Pattern not found in new.html"
fi
