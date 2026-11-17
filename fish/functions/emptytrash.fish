# Empty the Trash on the main HDD and clear download history from quarantine. https://mths.be/bum
function emptytrash
    sudo rm -rfv ~/.Trash
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
end
