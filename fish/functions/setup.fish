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
    abbr ber bundle exec rspec
    abbr besr bundle exec spring rails
    abbr besrs bundle exec spring rails s
    abbr besrc bundle exec spring rails c
    abbr bi bundle install
    abbr dcu docker-compose up -d
    abbr dcd docker-compose down
    abbr ga git add
    abbr gco git checkout
    abbr gc git commit -m
    abbr gd git diff
    abbr gf git fetch
    abbr gfo git fetch origin
    abbr gm git merge FETCH_HEAD --ff-only
    abbr gpl git pull
    abbr gps git push
    abbr gpsf git push --force-with-lease
    abbr gr git rebase
    abbr grm git rebase master
    abbr grom git rebase origin/master
    abbr gs git status
    abbr ll ls -lhA
    abbr mci mvn clean install
    abbr mcp mvn clean pre-integration-test
    abbr rc rails console
    abbr rps rails parallel:spec
    abbr rs rails server
    abbr rrd rails db:drop db:create db:migrate && RAILS_ENV=test rake db:drop db:create db:structure:load && DISABLE_SPRING=1 rake parallel:prepare && rake db:seed:clioco
    abbr ta terraform apply
    abbr ta0 terraform apply --refresh=false
    abbr tp terraform plan
    abbr tp0 terraform plan --refresh=false
    abbr tr terraform refresh
    abbr ts terraform state
    abbr tsl terraform state list
    abbr tsm terraform state move

    fisher
end
