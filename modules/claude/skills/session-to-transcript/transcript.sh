#!/usr/bin/env bash

# Writes a simple markdown transcript of a Claude Code session: what the user typed and the text Claude replied with.
# Thinking, tool calls, tool results, system reminders, meta messages and subagent turns are left out.
#   transcript.sh [output] [session.jsonl]
# output is a file (ends in .md) or a directory, default ./artifacts. session.jsonl defaults to the newest session
# file of the current session (CLAUDE_CODE_SESSION_ID, which Claude Code sets), else the newest in the current
# directory's project.
# Prints the path written.

set -euo pipefail

OUTPUT="${1:-artifacts}"
SESSION="${2:-}"

if [ -z "$SESSION" ]; then
    # Claude Code names the project folder after the working directory, with / and . turned into -
    PROJECT="$HOME/.claude/projects/$(pwd -P | sed 's/[^A-Za-z0-9]/-/g')"
    if [ -n "${CLAUDE_CODE_SESSION_ID:-}" ]; then
        SESSION="$PROJECT/$CLAUDE_CODE_SESSION_ID.jsonl"
    else
        SESSION="$(ls -t "$PROJECT"/*.jsonl 2>/dev/null | head -n 1 || true)"
    fi
    if [ -z "$SESSION" ]; then
        echo "No session files found in $PROJECT" >&2
        exit 1
    fi
fi
if [ ! -f "$SESSION" ]; then
    echo "No such session file: $SESSION" >&2
    exit 1
fi

ID="$(basename "$SESSION" .jsonl)"
case "$OUTPUT" in
    *.md) FILE="$OUTPUT" ;;
    *) FILE="$OUTPUT/transcript-$(date +%Y-%m-%d)-${ID:0:8}.md" ;;
esac
mkdir -p "$(dirname "$FILE")"

# Text of a message: a string, or the text blocks of an array. Only blocks of type text count, so tool results and
# thinking drop out. Injected <system-reminder> blocks are removed, and anything left empty is skipped.
jq -r --arg id "$ID" '
    def text:
        .message.content
        | if type == "string" then .
          else map(select(.type == "text") | .text) | join("\n\n") end
        | gsub("<system-reminder>(.|\n)*?</system-reminder>"; "")
        | gsub("^\\s+|\\s+$"; "");

    # Shell command typed with the ! prefix; its output wrapper is dropped
    def bash: capture("^<bash-input>(?<cmd>(.|\n)*)</bash-input>$").cmd // empty;

    # Slash command typed by the user
    def slash: capture("<command-name>(?<n>[^<]*)</command-name>(.|\n)*?(<command-args>(?<a>[^<]*)</command-args>)?").n // empty;

    [ .[] | select((.type == "user" or .type == "assistant") and (.isSidechain | not) and (.isMeta | not)) ] as $turns
    | "# Session \($id)\n",
      (range(0; $turns | length) as $i | $turns[$i] as $t | ($t | text) as $body
        | if $body == "" then empty
          # Claude text split around tool calls reads as one reply: head it once
          elif $t.type == "assistant" then
              (if ([$turns[:$i][] | select(text != "")] | last | .type) == "assistant" then "" else "## Claude\n\n" end) + "\($body)\n"
          elif ($body | test("^<bash-stdout>|^<local-command-")) then empty
          elif ($body | test("^<bash-input>")) then "## You\n\n`! \($body | bash)`\n"
          elif ($body | test("^<command-name>")) then "## You\n\n`\($body | slash)`\n"
          else "## You\n\n\($body)\n" end)
' -s "$SESSION" > "$FILE"

echo "$FILE"
