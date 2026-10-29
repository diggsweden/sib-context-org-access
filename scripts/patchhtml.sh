#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage:
  patchhtml.sh <markdown-file> <html-file>

- Replaces INSERT:<key> markers in HTML using snippets found in HTML comments
  immediately following INSERT:<key> lines in the Markdown.
- Inserts a fixed logo snippet immediately after the opening <body> tag.

Edits the HTML file in-place.
EOF
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

[ $# -eq 2 ] || { usage >&2; exit 1; }

md_file=$1
html_file=$2

[ -f "$md_file" ] || fail "Markdown file not found: $md_file"
[ -f "$html_file" ] || fail "HTML file not found: $html_file"

tmp="${html_file}.tmp.$$"

awk '
  # ---------- PASS 1: Parse Markdown ----------
  FNR == NR {
    line = $0

    if (line ~ /^[[:space:]]*INSERT:[A-Za-z0-9_.-]+[[:space:]]*$/) {
      key = line
      sub(/^[[:space:]]*INSERT:/, "", key)
      sub(/[[:space:]]*$/, "", key)

      pending_key = key
      pending = 1
      in_comment = 0
      buf = ""
      next
    }

    if (pending) {
      if (!in_comment && index(line, "<!--") > 0) {
        in_comment = 1
        sub(/^.*<!--[[:space:]]*/, "", line)

        if (index(line, "-->") > 0) {
          sub(/[[:space:]]*-->.*$/, "", line)
          buf = buf line
          insert[pending_key] = buf
          pending = 0
          in_comment = 0
          buf = ""
          next
        }

        buf = buf line "\n"
        next
      }

      if (in_comment) {
        if (index(line, "-->") > 0) {
          sub(/[[:space:]]*-->.*$/, "", line)
          buf = buf line
          insert[pending_key] = buf
          pending = 0
          in_comment = 0
          buf = ""
          next
        } else {
          buf = buf line "\n"
          next
        }
      }

      if (line ~ /[^[:space:]]/) {
        pending = 0
      }

      next
    }

    next
  }

  # ---------- PASS 2: Patch HTML ----------
  BEGIN {
    body_logo = "<div><img style=\"margin-bottom: 24px;\" align=\"left\" src=\"img/sweden-connect.png\"></img></div>"
    logo_inserted = 0
    body_seen = 0
  }

  {
    line = $0

    # Insert logo immediately after opening <body ...>
    if (!logo_inserted) {
      if (!body_seen) {
        if (line ~ /<body[[:space:]>]/) {
          body_seen = 1
          print line
          if (index(line, ">") > 0) {
            print body_logo
            logo_inserted = 1
          }
          next
        }
      } else {
        print line
        if (index(line, ">") > 0) {
          print body_logo
          logo_inserted = 1
        }
        next
      }
    }

    # If this is a paragraph that contains INSERT:<key>, replace the whole <p>...</p>
    # This avoids putting block markup inside <p>, which breaks layout.
    if (line ~ /^[[:space:]]*<p[[:space:]][^>]*>.*INSERT:[A-Za-z0-9_.-]+.*<\/p>[[:space:]]*$/) {
      # Find first token on the line
      if (match(line, /INSERT:[A-Za-z0-9_.-]+/)) {
        token = substr(line, RSTART, RLENGTH)
        key = substr(token, 8)

        if (key in insert) {
          # Wrap the inserted HTML as a block-level figure container.
          # (Adjust this wrapper if you want something else.)
          print "<div class=\"figure\">"
          print insert[key]
          print "</div>"
          next
        }
      }
      # If we cannot replace, fall through and print as-is
    }

    # Otherwise: do inline replacements (safe for inline HTML snippets)
    while (match(line, /INSERT:[A-Za-z0-9_.-]+/)) {
      token = substr(line, RSTART, RLENGTH)
      key = substr(token, 8)

      if (key in insert) {
        pre = substr(line, 1, RSTART - 1)
        post = substr(line, RSTART + RLENGTH)
        line = pre insert[key] post
      } else {
        break
      }
    }

    print line
  }
' "$md_file" "$html_file" > "$tmp"

mv -f "$tmp" "$html_file"
