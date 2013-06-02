require("awful")
require("beautiful")
beautiful.init("/home/sunny/.config/awesome/theme.lua")

--/// Volume Config and widget
volumecfg = {}
volumecfg.cardid  = 0
volumecfg.channel = "Master"
volumetext = widget({ type = "textbox", name = "volumetext" })
volumetext.align = "left"
-- command must start with a space!
volumecfg.mixercommand = function (command)
    local fd = io.popen("amixer -c " .. volumecfg.cardid .. command)
    local status = fd:read("*all")
    fd:close()
    local volume = string.match(status, "(%d?%d?%d)%%")
    volume = string.format("% 3d", volume)
    status = string.match(status, "%[(o[^%]]*)%]")
    if string.find(status, "on", 1, true) then 
        volume = volume 
    else 
        volume = "MUTE"
    end
    volumetext.text = '<span color="'..beautiful.fg_focus..'">'..volume..'</span>'
end
volumecfg.update = function () volumecfg.mixercommand(" sget " .. volumecfg.channel) end
volumecfg.up 	 = function () volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1+") end
volumecfg.down 	 = function () volumecfg.mixercommand(" sset " .. volumecfg.channel .. " 1-") end
volumecfg.toggle = function () volumecfg.mixercommand(" sset " .. volumecfg.channel .. " toggle") end
volumetext:buttons(awful.util.table.join(
    awful.button({ }, 4, function () volumecfg.up() end),
    awful.button({ }, 5, function () volumecfg.down() end),
    awful.button({ }, 1, function () volumecfg.toggle() end),
    awful.button({ }, 3, function () exec(terminal .. " -e alsamixer") end)))
volumecfg.update()
volumetimer = timer({ timeout = 30 })
volumetimer:add_signal( "timeout", function() volumecfg.update() end)
volumetimer:start()
--///
