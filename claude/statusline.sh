#! /usr/bin/env sh
# Claude Code status line: model, directory and context window usage.
# Claude Code pipes session JSON on stdin; whatever we print becomes the status line.

# Quality degrades with absolute tokens, not window percentage, so a 1M window
# gets no extra headroom. Green until WARN_TOKENS, yellow until LIMIT_TOKENS,
# red after that.
WARN_TOKENS=120000
LIMIT_TOKENS=150000
DEFAULT_WINDOW_SIZE=200000

# The bar has one cell per TOKENS_PER_CELL up to LIMIT_TOKENS, plus one overflow
# cell that lights up once usage goes beyond LIMIT_TOKENS.
TOKENS_PER_CELL=10000
BUDGET_CELLS=$((LIMIT_TOKENS / TOKENS_PER_CELL))
BAR_CELLS=$((BUDGET_CELLS + 1))

COLOR_GREEN=32
COLOR_YELLOW=33
COLOR_RED=31

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
size=$(echo "$input" | jq -r ".context_window.context_window_size // $DEFAULT_WINDOW_SIZE")

if [ -z "$pct" ]; then
    printf '%s · %s · ctx --' "$model" "${dir##*/}"
    exit 0
fi

pct=$(printf '%.0f' "$pct")
tokens=$((size * pct / 100))

if [ "$tokens" -ge "$LIMIT_TOKENS" ]; then
    color=$COLOR_RED
elif [ "$tokens" -ge "$WARN_TOKENS" ]; then
    color=$COLOR_YELLOW
else
    color=$COLOR_GREEN
fi

if [ "$tokens" -gt "$LIMIT_TOKENS" ]; then
    filled=$BAR_CELLS
else
    filled=$((tokens / TOKENS_PER_CELL))
fi
bar=""
i=0
while [ "$i" -lt "$BAR_CELLS" ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$((i + 1))
done

printf '%s · %s · \033[%sm%s %sk/%sk\033[0m' "$model" "${dir##*/}" "$color" "$bar" "$((tokens / 1000))" "$((LIMIT_TOKENS / 1000))"
