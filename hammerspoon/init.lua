require "hyper"
require "lockscreen"
require "minimising"
require "togglevpn"
require "spectacle"

-----------------------------------------------
-- Reload config on write
-----------------------------------------------
function reload_config(files)
  hs.reload()
end

hyper:bind({}, "r", function()
  reload_config()
  hyper.triggered = true
end)

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("Config loaded")
