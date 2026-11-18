# - Scans ~/foundry plus every git repo in ~/foundry/repos and ~/foundry/legacy-repos for linked worktrees whose branch is already merged into the default branch (origin/HEAD).
# - Prunes stale worktree metadata in each repo, then lists the merged worktrees. Dry run unless -r/--remove is passed.
# - With -r/--remove it runs `git worktree remove` (which refuses worktrees with untracked or modified files) and then `git branch -d`.
# - Add -f/--force (i.e. -rf) to remove those worktrees anyway, discarding their untracked and uncommitted changes.
# - Add -t/--time to also select worktrees whose branch's last commit is older than 2 weeks, merged or not. Unmerged branches are kept (`git branch -d` refuses them), so only the checkout is removed.
# - Squash-merged branches are not ancestors of the default branch, so only -t will pick them up (once they are old enough).
function worktree-cleanup --description 'Lists (or with -r removes, -rf forces, -t adds worktrees idle for 2+ weeks) linked worktrees merged into the default branch across ~/foundry, repos/ and legacy-repos/'
    argparse r/remove f/force t/time -- $argv; or return
    if set -q _flag_force; and not set -q _flag_remove
        echo "worktree-cleanup: -f/--force only applies with -r/--remove" >&2
        return 1
    end

    set -l force_flag
    set -q _flag_force; and set force_flag --force

    set -l cutoff (math (date +%s) - 14 \* 86400)

    for d in ~/foundry ~/foundry/repos/*/ ~/foundry/legacy-repos/*/
        set d (string trim --right --chars=/ $d)
        test -e $d/.git; or continue

        git -C $d worktree prune

        set -l default (git -C $d symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
        test -n "$default"; or continue

        set -l n 0
        set -l path
        for line in (git -C $d worktree list --porcelain)
            switch $line
                case 'worktree *'
                    set n (math $n + 1)
                    set path (string replace 'worktree ' '' -- $line)
                case 'branch *'
                    # The first entry is the main checkout, which is never removed.
                    test $n -gt 1; or continue
                    set -l branch (string replace 'branch refs/heads/' '' -- $line)

                    set -l reason
                    if git -C $d merge-base --is-ancestor $branch $default
                        set reason merged
                    else if set -q _flag_time; and test (git -C $d log -1 --format=%ct $branch) -lt $cutoff
                        set reason stale
                    end
                    test -n "$reason"; or continue

                    if set -q _flag_remove
                        echo "removing ($reason): $path ($branch)"
                        git -C $d worktree remove $force_flag $path; and git -C $d branch -d $branch
                    else
                        echo "$reason: $path ($branch)"
                    end
            end
        end
    end
end
