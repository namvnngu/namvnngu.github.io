#!/usr/bin/env bash

_toc_out="    <ul id=\"toc\" class=\"[ toc ]\">\n"
_bm_out="    <article>\n"
_last_category=""
_blocks_path="./src/blocks"

while IFS="|" read -r __category __title __url; do
  category="${__category:-Unknown}"
  title="${__title:-${__url}}"
  url="${__url}"
  id=$(tr '[:upper:]' '[:lower:]' <<< "${category}")
  id=${id//[ :\/]/-}

  if [[ -z "${url}" ]]; then
    continue
  fi

  if [[ "${category}" != "${_last_category}" ]]; then
    if [[ -n "${_last_category}" ]]; then
      _bm_out="${_bm_out}      </ul>\n"
      _bm_out="${_bm_out}      <!-- block-start: back-to-top -->\n"
      _bm_out="${_bm_out}      <!-- block-end: back-to-top -->\n"
    fi

    _toc_out="${_toc_out}      <li><a href=\"#${id}\" id=\"toc-${id}\">${category}</a></li>\n"

    _bm_out="${_bm_out}      <h2 id=\"${id}\"><a href=\"#${id}\">${category}</a></h2>\n"
    _bm_out="${_bm_out}      <ul>\n"

    _last_category="${category}"
  fi

  _bm_out="${_bm_out}        <li><a href=\"${url}\" target=\"_blank\" data-anchor=\"none\">${title}</a></li>\n"
done < <(bm view)

_toc_out="${_toc_out}    </ul>\n"

_bm_out="${_bm_out}      </ul>\n"
_bm_out="${_bm_out}      <!-- block-start: back-to-top -->\n"
_bm_out="${_bm_out}      <!-- block-end: back-to-top -->\n"
_bm_out="${_bm_out}    </article>\n"

printf "%b" "${_toc_out}\n${_bm_out}" > "${_blocks_path}/bookmarks.html"
