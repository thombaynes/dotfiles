#! /usr/bin/env sh
#
# Render shortcuts/src/*.txt into two-column markdown files next to this script.
#   ./generate.sh          regenerate every *.md
#   ./generate.sh --check  list bindings in my configs that are missing from src/

DIR=$(cd "$(dirname "$0")" && pwd)
ROOT=$(dirname "$DIR")
SRC="$DIR/src"

# Source format (one file per tool):
#   # Title                        document title
#   > text                         intro line
#   ## Section                     starts a table
#   key | action                   one shortcut; "a / b" renders as `a` / `b`
#   @abbreviations path/to/file    expands every `abbr x y` line in that file (path from repo root)
render() {
    awk -v root="$ROOT" '
    function flush(   i, n, kw, aw, k, a, row) {
        if (count == 0) return
        n = int((count + 1) / 2)
        kw[1] = kw[2] = 3; aw[1] = aw[2] = 6
        for (i = 1; i <= count; i++) {
            c = (i % 2 == 1) ? 1 : 2
            if (length(keys[i]) > kw[c]) kw[c] = length(keys[i])
            if (length(acts[i]) > aw[c]) aw[c] = length(acts[i])
        }
        printf "| %s | %s | %s | %s |\n", pad("Key", kw[1]), pad("Action", aw[1]), pad("Key", kw[2]), pad("Action", aw[2])
        printf "| %s | %s | %s | %s |\n", dashes(kw[1]), dashes(aw[1]), dashes(kw[2]), dashes(aw[2])
        for (i = 1; i <= count; i += 2) {
            k = (i + 1 <= count) ? keys[i + 1] : ""; a = (i + 1 <= count) ? acts[i + 1] : ""
            printf "| %s | %s | %s | %s |\n", pad(keys[i], kw[1]), pad(acts[i], aw[1]), pad(k, kw[2]), pad(a, aw[2])
        }
        print ""
        count = 0
    }
    function pad(s, w) { while (length(s) < w) s = s " "; return s }
    function dashes(w,   s) { s = ""; while (length(s) < w) s = s "-"; return s }
    function keycell(k,   n, parts, i, out) {
        n = split(k, parts, " / ")
        for (i = 1; i <= n; i++) out = out (i > 1 ? " / " : "") "`" parts[i] "`"
        return out
    }
    function add(k, a) { count++; keys[count] = k; acts[count] = a }
    /^@abbreviations / {
        file = root "/" $2
        cmd = "sed -nE \"s/^[[:space:]]*abbr ([a-z][^ ]*) ([^#]*[^# ]).*$/\\1\\t\\2/p\" \"" file "\""
        while ((cmd | getline line) > 0) {
            split(line, p, "\t"); gsub(/\\/, "", p[2]); gsub(/\|/, "\\|", p[2])
            add("`" p[1] "`", "`" p[2] "`")
        }
        close(cmd); next
    }
    /^# /  { print; print ""; next }
    /^> /  { print substr($0, 3); print ""; next }
    /^## / { flush(); print; print ""; next }
    /^[[:space:]]*$/ { next }
    {
        i = index($0, " | ")
        gsub(/\|/, "\\|", $0); i = index($0, " \\| ")
        add(keycell(substr($0, 1, i - 1)), substr($0, i + 4))
    }
    END { flush() }
    ' "$1"
}

check() {
    missing=0
    # $1 tool, $2 file of bindings found in the config (one per line)
    report() {
        while IFS= read -r key; do
            [ -n "$key" ] || continue
            grep -qF -- "$key" "$SRC/$1.txt" || { echo "$1: $key"; missing=1; }
        done < "$2"
    }
    tmp=$(mktemp)

    # tmux: bind / bind-key lines; the key is the first non-flag argument after any -T <table>
    grep -E '^[[:space:]]*bind(-key)?[[:space:]]' "$ROOT/tmux/.tmux.conf" | awk '
        { for (i = 2; i <= NF; i++) {
            if ($i == "-T") { i++; continue }
            if ($i ~ /^-./) continue
            k = $i; gsub(/^[\x27"]|[\x27"]$/, "", k); if (k == "\\\\") k = "\\"; print k; break } }' | sort -u > "$tmp"
    report tmux "$tmp"

    # neovim: map() helpers (plugins and config/keymaps.lua), and lazy.nvim `keys` specs
    {
        grep -hE 'map\("[^"]+"|keys = \{ \{ "[^"]+"' "$ROOT"/vim/nvim/lua/plugins/*.lua | sed -E 's/.*(map\(|\{ \{ )"([^"]+)".*/\2/'
        grep -hE 'map\("[a-z]+", "[^"]+"' "$ROOT"/vim/nvim/lua/config/keymaps.lua | sed -E 's/.*map\("[a-z]+", "([^"]+)".*/\1/'
    } | sed -E 's/<[Ll]eader>/<leader>/; s/<[MmDd]-(.)>/Alt-\1/' | sort -u > "$tmp"
    report neovim "$tmp"

    # fish: custom `bind` lines (abbreviations are generated, so never missing)
    grep -rhE '^[[:space:]]*bind[[:space:]]' "$ROOT/fish/config.fish" "$ROOT/fish/functions" 2>/dev/null | awk '{ print $2 }' | sort -u > "$tmp"
    report fish "$tmp"

    rm -f "$tmp"
    if [ "$missing" = 0 ]; then echo "Every binding found in the configs is documented."; fi
}

if [ "$1" = "--check" ]; then
    check
    exit 0
fi

for src in "$SRC"/*.txt; do
    out="$DIR/$(basename "$src" .txt).md"
    render "$src" > "$out" && echo "Wrote $out"
done
