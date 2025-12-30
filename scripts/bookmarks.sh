#!/usr/bin/env bash

toc_out="    <ul id=\"toc\" class=\"[ toc ]\">\n"
bm_out="    <article>\n"
last_category=""
blocks_path="./src/blocks"

while IFS="|" read -r __category __title __url; do
  category="${__category:-Unknown}"
  title="${__title:-${__url}}"
  url="${__url}"
  id=$(tr '[:upper:]' '[:lower:]' <<< "${category}")
  id=${id//[ :\/]/-}

  if [[ -z "${url}" ]]; then
    continue
  fi

  if [[ "${category}" != "${last_category}" ]]; then
    if [[ -n "${last_category}" ]]; then
      bm_out="${bm_out}      </ul>\n"
      bm_out="${bm_out}      <!-- block-start: back-to-top -->\n"
      bm_out="${bm_out}      <!-- block-end: back-to-top -->\n"
    fi

    toc_out="${toc_out}      <li><a href=\"#${id}\" id=\"toc-${id}\">${category}</a></li>\n"

    bm_out="${bm_out}      <h2 id=\"${id}\"><a href=\"#${id}\">${category}</a></h2>\n"
    bm_out="${bm_out}      <ul>\n"

    last_category="${category}"
  fi

  bm_out="${bm_out}        <li><a href=\"${url}\" target=\"_blank\" data-anchor=\"none\">${title}</a></li>\n"
done < <(bm view)

toc_out="${toc_out}    </ul>\n"

bm_out="${bm_out}      </ul>\n"
bm_out="${bm_out}      <!-- block-start: back-to-top -->\n"
bm_out="${bm_out}      <!-- block-end: back-to-top -->\n"
bm_out="${bm_out}    </article>\n"

printf "%b" "${toc_out}\n${bm_out}" > "${blocks_path}/bookmarks.html"
