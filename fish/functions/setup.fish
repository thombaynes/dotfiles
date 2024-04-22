#!/usr/local/bin/fish
## Defines abbreviations
function setup
    for abbreviation in (abbr -l)
        abbr -e $abbreviation
    end

    abbr ai asdf install
    abbr bs brew services
    abbr bd brew doctor
    abbr be bundle exec
    abbr bi bundle install
    abbr cc bundle exec rubocop -c .rubocop-codeclimate.yml
    abbr dcu docker-compose up -d
    abbr dcd docker-compose down
    abbr ga git add
    abbr gb git branch
    abbr gbl git branch --list
    abbr gbd git branch -d
    abbr gc git commit -m
    abbr gco git checkout
    abbr gcob git checkout -b
    abbr gd git diff
    abbr gf git fetch
    abbr gfo git fetch origin
    abbr gh git hist
    abbr gm git merge FETCH_HEAD --ff-only
    abbr gpl git pull
    abbr gps git push
    abbr gpsf git push --force-with-lease
    abbr grb git rebase
    abbr grba git rebase --abort
    abbr grbc git rebase --continue
    abbr grbi git rebase -i master
    abbr grbm git rebase master
    abbr grbom git rebase origin/master
    abbr grsh git reset --hard origin/\(git branch --show-current\)
    abbr grss git reset --soft HEAD^
    abbr gs git status
    abbr gsh git stash
    abbr k kubectl
    abbr ka kubectl apply -f
    abbr kc kubectl create -f
    abbr kds kubectl describe
    abbr kdl kubectl delete
    abbr ke kubectl edit
    abbr kge kubectl get all -o wide
    abbr kgn kubectl get nodes -o wide
    abbr kgp kubectl get pods -o wide
    abbr kgr kubectl get replicasets -o wide
    abbr krs kubectl rollout status
    abbr krh kubectl rollout history
    abbr ll ls -lhA
    abbr mci mvn clean install
    abbr mcp mvn clean pre-integration-test
    abbr rc bundle exec rails console
    abbr rdb rails db:
    abbr rdbm rails db:migrate
    abbr rdbp rails db:prepare
    abbr rdbr rails db:reset
    abbr rmod rspec \(git ls-files --modified spec\)
    abbr rps rails parallel:spec
    abbr rs rails server
    abbr rsp bundle exec rspec
    abbr sr bundle exec spring rails
    abbr srs bundle exec spring rails s
    abbr src bundle exec spring rails c
    abbr ta terraform apply
    abbr ta0 terraform apply --refresh=false
    abbr tp terraform plan
    abbr tp0 terraform plan --refresh=false
    abbr tr terraform refresh
    abbr ts terraform state
    abbr tsl terraform state list
    abbr tsm terraform state move
    abbr t bin/utt
    abbr tpl bin/utt pull
    abbr tps bin/utt push
    abbr tpr bin/utt prune

    fisher
end
