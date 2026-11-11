#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage:
  tohtml.sh <markdown-file> [-draft [TAG] | -release]

Modes:
  -draft [TAG]   Generate draft HTML. Optional TAG defaults to "main".
  -release       Generate release HTML.
EOF
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

mode=""
draft_tag="main"
md_file=""

# Parse args (flags may appear before or after the file)
while [ $# -gt 0 ]; do
  case "$1" in
    -draft)
      [ "${mode:-}" = "release" ] && fail "Cannot use -draft and -release at the same time."
      mode="draft"
      shift
      if [ $# -gt 0 ] && [ "${1#-}" = "$1" ]; then
        draft_tag="$1"
        shift
      fi
      ;;
    -release)
      [ "${mode:-}" = "draft" ] && fail "Cannot use -draft and -release at the same time."
      mode="release"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      fail "Unknown option: $1"
      ;;
    *)
      if [ -z "${md_file:-}" ]; then
        md_file="$1"
        shift
      else
        fail "Unexpected extra argument: $1"
      fi
      ;;
  esac
done

[ -n "${md_file:-}" ] || { usage >&2; exit 1; }
[ -f "$md_file" ] || fail "Markdown file not found: $md_file"

if [ -z "${mode:-}" ]; then
  mode="draft"
  echo "Generating in draft mode"
fi

# Absolute directory of the markdown file (portable)
md_dir=$(CDPATH= cd -- "$(dirname -- "$md_file")" && pwd)
md_base=$(basename -- "$md_file")

# Extract seriesInfo.value in a POSIX-awk compatible way:
# - enter section on [seriesInfo]
# - leave section on next [something]
# - within section, find: value = "..."
series_value=$(
  awk '
    BEGIN { in_series=0 }
    /^[[:space:]]*\[seriesInfo\][[:space:]]*$/ { in_series=1; next }
    in_series && /^[[:space:]]*\[[^]]+\][[:space:]]*$/ { in_series=0 }
    in_series && /^[[:space:]]*value[[:space:]]*=/ {
      line=$0
      sub(/^[[:space:]]*value[[:space:]]*=[[:space:]]*"/, "", line)
      sub(/"[[:space:]]*$/, "", line)
      print line
      exit
    }
  ' "$md_dir/$md_base"
)

[ -n "${series_value:-}" ] || fail "Could not find value = \"...\" under [seriesInfo] in: $md_file"

html_name="${series_value}.html"
xml_name="${series_value}.xml"

# Run docker from md_dir so the /data mount matches and output files appear there
(
  cd "$md_dir"
  docker run --rm -v "$(pwd)":/data danielfett/markdown2rfc "$md_base"
)

html_src="$md_dir/$html_name"
xml_src="$md_dir/$xml_name"

[ -f "$html_src" ] || fail "Expected HTML not found after docker run: $html_src"
[ -f "$xml_src" ] || fail "Expected XML not found after docker run: $xml_src"

# xml2rfc double-encodes numeric character references that markdown2rfc emitted
# for non-ASCII link text (e.g. &amp;#246; → &#246;), producing literal "&#NNN;"
# in the browser.  Decode the six Swedish characters back to single-encoded form.
sed -i '' \
  -e 's/&amp;#229;/\&#229;/g' \
  -e 's/&amp;#228;/\&#228;/g' \
  -e 's/&amp;#246;/\&#246;/g' \
  -e 's/&amp;#197;/\&#197;/g' \
  -e 's/&amp;#196;/\&#196;/g' \
  -e 's/&amp;#214;/\&#214;/g' \
  "$html_src"

# Patch generated HTML based on INSERT:<key> blocks in the Markdown
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
"$script_dir/patchhtml.sh" "$md_dir/$md_base" "$html_src"

if [ "$mode" = "release" ]; then
  dest_dir="$md_dir/docs"
  dest_file="$html_name"
else
  dest_dir="$md_dir/docs/drafts"
  dest_file="${series_value}-${draft_tag}.html"
fi

mkdir -p "$dest_dir"
mv -f "$html_src" "$dest_dir/$dest_file"
rm -f "$xml_src"

# Copy all images to both release and draft image directories
if [ -d "$md_dir/img" ]; then
  mkdir -p "$md_dir/docs/img" "$md_dir/docs/drafts/img"
  cp -R "$md_dir/img/." "$md_dir/docs/img/"
  cp -R "$md_dir/img/." "$md_dir/docs/drafts/img/"
fi

echo "HTML placed at: $dest_dir/$dest_file"
