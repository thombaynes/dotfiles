function tmux-all --description "Start every tmuxinator project in order, then attach to foundry"
    set -l projects tdot foundry platform-foundations authentication orders
    set -l landing foundry

    for p in $projects
        tmux has-session -t $p 2>/dev/null; or tmuxinator start $p --no-attach
    end

    if set -q TMUX
        tmux switch-client -t $landing
    else
        tmux attach -t $landing
    end
end
