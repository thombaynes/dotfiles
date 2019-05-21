## Defines abbreviations
function setup
    for abbreviation in (abbr -l)
        abbr -e $abbreviation
    end
    abbr ai asdf install
    abbr bs brew services
    abbr bd brew doctor
    abbr be bundle exec
    abbr c curl
    abbr g git
    abbr gf git fetch
    abbr gs git status
    abbr gc git commit -m
    abbr gm git merge FETCH_HEAD --ff-only
    abbr gr git rb FETCH_HEAD
    abbr ga git add
    abbr gp git pull
    abbr gd git diff
    abbr gco git checkout
    abbr ll ls -lhA
    abbr mci mvn clean install
    abbr mcp mvn clean pre-integration-test
    abbr r rails
    abbr rs rspec
    fisher
end
