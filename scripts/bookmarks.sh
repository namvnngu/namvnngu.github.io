#!/usr/bin/env bash

_out=""
_last_category=""
_blocks_path="./src/blocks"

while IFS="|" read -r __category __title __url; do
  category="${__category:-Unknown}"
  title="${__title:-${__url}}"
  url="${__url}"

  if [[ -z "${url}" ]]; then
    continue
  fi

  if [[ "${category}" != "${_last_category}" ]]; then
    if [[ -n "${_last_category}" ]]; then
      _out="${_out}      </ul>\n"
      _out="${_out}      <!-- block-start: back-to-top -->\n"
      _out="${_out}      <!-- block-end: back-to-top -->\n"
    fi
    _out="${_out}      <h2>${category}</h2>\n"
    _out="${_out}      <ul>\n"

    _last_category="${category}"
  fi

  _out="${_out}        <li><a href=\"${url}\" target=\"_blank\" data-anchor=\"none\">${title}</a></li>\n"
done < <(bm view)

_out="${_out}      </ul>\n"
_out="${_out}      <!-- block-start: back-to-top -->\n"
_out="${_out}      <!-- block-end: back-to-top -->\n"

printf "%b" "${_out}" > "${_blocks_path}/bookmarks.html"
