#!usr/local/bin/fish
# Run this in the morning to get setup for AWS
# Note that it depends on a which is another function, which depends on a zsh alias
function awslogin
    aws sso login --profile default && a engineering
end
