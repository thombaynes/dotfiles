# Expands the grbm abbreviation to a rebase onto the local copy of the repo's default branch (from origin/HEAD)
function __abbr_grbm
    echo git rebase (string replace origin/ '' (git symbolic-ref --short refs/remotes/origin/HEAD))
end
