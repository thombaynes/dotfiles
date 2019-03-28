tell application "System Events"
    tell current location of network preferences
        set myVPN to the service "RewardStream"
        if myVPN is not null then
            if current configuration of myVPN is not connected then
                connect myVPN
            else
                disconnect myVPN
            end if
        end if
    end tell
end tell
