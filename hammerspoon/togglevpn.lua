--------------------------------------------------------------
-- Connect to a VPN named "RewardStream" with Applescript file
--------------------------------------------------------------

hyper:bind({}, "e", function()
  hs.osascript.applescriptFromFile("togglevpn.applescript")
  hyper.triggered = true
end)
