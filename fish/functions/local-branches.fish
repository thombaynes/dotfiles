#!/usr/local/bin/fish
# - Scans every git repo in ~/foundry/repos and prints its current branch.
# - Shows 🟢 if the repo is on its default branch (origin/HEAD), 🔴 if it is not.
# - Shows a green ✔ if the working tree is clean, or a red ╱ if there are staged, unstaged or untracked changes.
function local-branches --description 'Lists each repo in ~/foundry/repos with its branch, whether it is on the default branch, and whether it has changes'
    set -l repo_base ~/foundry/repos

    printf "%-45s %-20s %-10s %s\n" Repo Branch Default? Changes?

    for d in $repo_base/*/
        test -e $d.git; or continue
        set -l name (basename $d)
        set -l branch (git -C $d branch --show-current)
        test -z "$branch"; and set branch "(detached HEAD)"
        set -l default (git -C $d symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace origin/ '')

        set -l icon 🔴
        test "$branch" = "$default"; and set icon 🟢

        set -l changes (set_color green)✔(set_color normal)
        test -n "$(git -C $d status --porcelain)"; and set changes (set_color red)╱(set_color normal)

        printf "%-45s %-20s %-9s %s\n" $name $branch $icon $changes
    end
end
