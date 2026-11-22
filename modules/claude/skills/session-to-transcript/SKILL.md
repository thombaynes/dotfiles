---
name: session-to-transcript
description: Save a plain markdown transcript of the current session (your messages and Claude's replies only) to artifacts/ or a location you give.
disable-model-invocation: true
argument-hint: "[output file or directory]"
allowed-tools: Bash(~/.claude/skills/session-to-transcript/transcript.sh:*)
---

Run the script below and report the path it prints. Do not read, summarise or rewrite the transcript yourself: the script is deterministic and does all the work.

```
~/.claude/skills/session-to-transcript/transcript.sh [output]
```

- No argument: the script writes `artifacts/transcript-<date>-<session>.md` under the current directory.
- If the user gave a location in `$ARGUMENTS`, pass it as `[output]`. A path ending in `.md` is the file; anything else is a directory.
- Quote the path if it contains spaces.
- Tell the user the transcript is read from the session file on disk, so it stops at the previous turn and does not include this command's own turn.
- If the script fails, show its error as is.
