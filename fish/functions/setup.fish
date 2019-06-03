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
    abbr ga git add
    abbr gco git checkout
    abbr gc git commit -m
    abbr gd git diff
    abbr gf git fetch
    abbr gm git merge FETCH_HEAD --ff-only
    abbr gpl git pull
    abbr gps git push
    abbr gpsf git push --force-with-lease
    abbr gr git rebase
    abbr grm git rebase master
    abbr gs git status
    abbr ll ls -lhA
    abbr mci mvn clean install
    abbr mcp mvn clean pre-integration-test
    abbr rc rails console
    abbr rs rails server
    fisher
end
