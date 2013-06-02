local awful = require("awful")
local beautiful = require("beautiful")
local freedesktop_utils = require("freedesktop.utils")
local freedesktop_menu = require("freedesktop.menu")
--local themes = require("myrc.themes")

local io = io
local table = table
local awesome = awesome
local ipairs = ipairs
local os = os
local string = string
local mouse = mouse
local lookup_icon = freedesktop_utils.lookup_icon
module("myrc.mainmenu")

local env = {}

-- Reserved.
function init(enviroment)
    env = enviroment
end

-- Creates main menu
-- Note: Uses beautiful.icon_theme and beautiful.icon_theme_size
-- env - table with string constants - command line to different apps
function build()
    local terminal = "urxvtc "
    local man = "urxvtc -e man "
    local editor = "urxvtc -e vim "
    local browser = "chromium-browser "
    local run = "gmrun "
    local fileman = "pcmanfm "
    local xkill = env.xkill or "xkill" .. " "
    local shutdown = "/home/sunny/bin/gui-logout"
    local opera = "opera"
    local torrent = "transmission"
    local mediaplayer = "gnome-mplayer"
    local messenger = "pidgin" 
--  freedesktop_utils.terminal = terminal
--  freedesktop_utils.icon_theme = beautiful.icon_theme 
--  freedesktop_utils.icon_sizes = {beautiful.icon_theme_size}

    local myawesomemenu = { 
        { "Edit config", editor .. awful.util.getdir("config") .. "/rc.lua"},
        { "Edit theme", editor .. awful.util.getdir("config") .. "/theme.lua" },
        { "Edit widgets", editor .. awful.util.getdir("config") .. "/widgets.lua" },
        { "Edit main menu", editor .. awful.util.getdir("config") .. "/mainmenu.lua" },
        { "Restart", awesome.restart },
        { "Stop", awesome.quit } 
    }

    local appmenu_items = {}
    for _, item in ipairs(freedesktop_menu.new()) do table.insert(appmenu_items, item) end
    
    local mymainmenu_items = {
        { "Run", run, lookup_icon({ icon = 'gnome-run'}) },
        { "Terminal", terminal, lookup_icon({ icon = 'utilities-terminal' }) },
        { "File Manager", fileman, lookup_icon({ icon = 'file-manager' }) },
        { "Chromium", browser, lookup_icon({ icon = 'chromium-browser' }) },
        { "Opera", opera, lookup_icon({ icon = 'opera' }) },
        { "Torrents", torrent, lookup_icon({ icon = 'transmission' }) },
        { "Pidgin", messenger, lookup_icon({ icon = 'pidgin' }) },
        { " ", nil, nil}, --separator
        { "Applications", appmenu_items, lookup_icon({ icon = "start-here" }) },
        { " ", nil, nil}, --separator
        { "Awesome", myawesomemenu, lookup_icon({ icon = "gnome-klotski" }) },
        { "Quit", shutdown, lookup_icon({ icon = 'gnome-shutdown' }) }
    }

--[[    local mymainmenu_items_tail = {
        { " ", nil, nil}, --separator
--        { "Xkill", xkill },
--        { "Run", run },
        { "Quit", shutdown, lookup_icon({ icon = 'gnome-shutdown' }) },
    }]]
    
--    local mymainmenu_items = {}
--    for _, item in ipairs(mymainmenu_items_head) do table.insert(mymainmenu_items, item) end
--    for _, item in ipairs(freedesktop_menu.new()) do table.insert(mymainmenu_items, item) end
--    for _, item in ipairs(mymainmenu_items_tail) do table.insert(mymainmenu_items, item) end

   -- return awful.menu({ items = mymainmenu_items, x = 0, y = 0})
    return awful.menu({ items = mymainmenu_items })
end

