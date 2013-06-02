require("awful")
require("awful.rules")
require("awful.autofocus")
require("awful.startup_notification")
require("beautiful")
require("vicious")
require("freedesktop.utils")
require("freedesktop.menu")
require("widgets")
require("volume")

-- Themes file
beautiful.init("/home/sunny/.config/awesome/theme.lua")
-- Default apps
exec = awful.util.spawn
terminal = "urxvtc"
cli_editor = "vim"
gui_editor = "geany"
browser = "luakit"
gui_fm = "pcmanfm"
cli_fm = terminal .. " -e ranger"
system_monitor = terminal .. " -e htop"
media_player = "gnome-mplayer"
music_player = terminal .. " -e ncmpcpp"
smallterminal = terminal .. ' -title "SmallTerm"  -geometry 67x07-200-100'
gtk_settings = "lxappearance"
locker = "sflock"
imclient = "pidgin"
-- Default modkey.
modkey = "Mod4"
altkey = "Mod1"
-- Set wallpaper
exec("nitrogen --restore", false)

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.tile.top,
    awful.layout.suit.spiral,
    awful.layout.suit.magnifier,
    awful.layout.suit.max,
}

-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ " α ", " β ", " γ ", " δ ", " ε " }, s, layouts[1])
end

-- Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle(desktopmenu_args) end),
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)))

--/// GLOBAL KEYS BINDINGS
globalkeys = awful.util.table.join(
	-- Focus
    awful.key({ modkey }, "Left",
        function () awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end),
    awful.key({ modkey }, "Right",
        function () awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end end),

	-- Tag control
    awful.key({ altkey, "Control" }, "Left",  awful.tag.viewprev ),
    awful.key({ altkey, "Control" }, "Right", awful.tag.viewnext ),
    awful.key({ modkey,           }, "Up",    function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Down",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, altkey,   }, "Up",    function () awful.client.incwfact( 0.05)  end),
    awful.key({ modkey, altkey,   }, "Down",  function () awful.client.incwfact(-0.05)  end),
    awful.key({ modkey, "Control" }, "Up",    function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "Down",  function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Shift"   }, "Up",    function () awful.tag.incnmaster( 1)         end),
    awful.key({ modkey, "Shift"   }, "Down",  function () awful.tag.incnmaster(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	-- Awesome restart and quit
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Control" }, "q", awesome.quit),

	-- Layout manipulation
    awful.key({ modkey, "Shift" }, "Left",  function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Shift" }, "Right", function () awful.client.swap.byidx( 1)  end),
    awful.key({ modkey,         }, "u",     awful.client.urgent.jumpto),
   
	-- Program shortcuts
    awful.key({ modkey, }, "Return", function () exec(terminal, false) end),
    awful.key({ altkey, }, "F2", function () awful.util.spawn("dmenu-bind") end),
    awful.key({ modkey  }, "r", function () awful.util.spawn("gmrun") end),
    awful.key({ modkey, }, "w", function () exec(browser) end),
    awful.key({ modkey, }, "f", function () exec(cli_fm) end),
    awful.key({ modkey, }, "v", function () exec(media_player) end),
    awful.key({ modkey, }, "h", function () exec(system_monitor, false) end),
    awful.key({ modkey, }, "e", function () exec(gui_editor) end),
    awful.key({ modkey, }, "a", function () exec(gtk_settings) end),
    awful.key({ modkey, }, "n", function () exec(music_player, false) end),
    awful.key({ modkey, }, "t", function () exec(terminal " -e rtorrentd", false) end),
    awful.key({ modkey, }, "l", function () exec(locker, false) end),
    awful.key({ modkey, }, "p", function () exec(imclient, true) end),
    awful.key({ modkey, altkey }, "Return", function () exec(smallterminal, false) end),
    awful.key({ modkey, altkey }, "f", function () exec(gui_fm) end),
    awful.key({ modkey, altkey }, "n", function () exec("nitrogen --sort=alpha") end),
    awful.key({ modkey, altkey }, "a", function () exec(terminal .. " -e alsamixer", false) end),
	awful.key({ }, "XF86Launch2", function () exec("/home/sunny/bin/spegni", false) end),

	-- Volume Control
    awful.key({ }, "XF86AudioRaiseVolume", function () volumecfg.up() end),
    awful.key({ }, "XF86AudioLowerVolume", function () volumecfg.down() end),
    awful.key({ }, "XF86AudioMute",        function () volumecfg.toggle() end),

	-- MPD control
    awful.key({ modkey }, "XF86AudioPlay", function () exec("/home/sunny/bin/mpd-toggle", false) end),
    awful.key({	       }, "XF86AudioPlay", function () exec("mpc -q toggle", false) end),
    awful.key({	       }, "XF86AudioStop", function () exec("mpc -q stop", false) end),
    awful.key({	       }, "XF86AudioNext", function () exec("mpc -q next", false) end),
    awful.key({	       }, "XF86AudioPrev", function () exec("mpc -q prev", false) end),

	-- Menu
    awful.key({ modkey }, "Escape", function () mymainmenu:toggle(keymenu_args) end),
    awful.key({ altkey }, "Tab",    function () awful.menu.menu_keys.down = { "Down", "Alt_L" }
                                                local cmenu = awful.menu.clients({width=245}, keymenu_args ) end)
)

--/// CLIENT KEYS
clientkeys = awful.util.table.join(
 	 -- Kill
    awful.key({ modkey }, "c", function (c) c:kill() end),
	 -- Floating
    awful.key({ altkey }, "space", awful.client.floating.toggle ),
	 -- Swap to master
    awful.key({ altkey }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	 -- Redraw
    awful.key({ modkey }, "F1", function (c) c:redraw() end),
	 -- Fullscreen
    awful.key({ modkey }, "F11", function (c) c.fullscreen = not c.fullscreen  end),
	 -- On Top
    awful.key({ modkey }, "F5", function (c) c.ontop = not c.ontop end),
	 -- Remove Titlebars
    awful.key({ modkey }, "F3", function (c) if c.titlebar then awful.titlebar.remove(c) else awful.titlebar.add(c) end end),
	 -- Move to center
    awful.key({ modkey }, "#84", function (c) awful.placement.centered(c) end),
    awful.key({ modkey }, "#79", function (c) awful.placement.center_horizontal(c) end),
    awful.key({ modkey }, "#87", function (c) awful.placement.center_vertical(c) end),
	 
	 -- Toggle full maximize
    awful.key({ altkey }, "#84", function (c) c.maximized_horizontal, c.maximized_vertical = not c.maximized_horizontal, not c.maximized_vertical end),
	 -- Toggle vertical maximize
    awful.key({ modkey }, "KP_Next", function (c) c.maximized_vertical = not c.maximized_vertical end),
	-- Toggle horizontal maximize
    awful.key({ modkey }, "KP_Prior", function (c) c.maximized_horizontal = not c.maximized_horizontal end),  

	-- Move clients (up,down,left,right)
    awful.key({ modkey }, "#80", function (c) awful.client.moveresize(  0,-30, 0, 0) end),
    awful.key({ modkey }, "#88", function (c) awful.client.moveresize(  0, 30, 0, 0) end), 
    awful.key({ modkey }, "#83", function (c) awful.client.moveresize(-30, 0,  0, 0) end), 
    awful.key({ modkey }, "#85", function (c) awful.client.moveresize( 30, 0,  0, 0) end),
	-- To margins (up,down,left,right)
	awful.key({modkey,altkey}, "#80", function (c) local g = c:geometry(); g.y = 16; c:geometry(g) end), 
	awful.key({modkey,altkey}, "#88", function (c) local g, screen_area = c:geometry(), screen[c.screen].workarea
											g.y = screen_area.y + screen_area.height - g.height 
											c:geometry(g) end), 
	awful.key({modkey,altkey}, "#83", function (c) local g = c:geometry(); g.x= 0; c:geometry(g) end), 
	awful.key({modkey,altkey}, "#85", function (c) local g, screen_area = c:geometry(), screen[c.screen].workarea
											g.x = screen_area.x + screen_area.width - g.width 
											c:geometry(g) end), 

	-- Resize clients (up,down,left,right)
    awful.key({ altkey, }, "#80", function (c) awful.client.moveresize( 0, 0,  0,-30) end),
    awful.key({ altkey, }, "#88", function (c) awful.client.moveresize( 0, 0,  0, 30) end), 
    awful.key({ altkey, }, "#83", function (c) awful.client.moveresize( 0, 0,-30, 0 ) end), 
    awful.key({ altkey, }, "#85", function (c) awful.client.moveresize( 0, 0, 30, 0 ) end) 
)
--///

-- Compute the maximum number of digit we need, limited to 9
keynumber = 5
--[[keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end]]

-- Bind all key numbers to tags.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_focus,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
	     	         size_hints_honor = true, },},
	{ rule = { class = 'URxvt' }, properties = { size_hints_honor = false } },
    { rule_any = { class = { "MPlayer", "Gnome-mplayer", "sxiv", "Viewnior" }, },         
	    properties = { floating = true },},
    { rule = { name = "SmallTerm" }, 
		properties = { floating = true, ontop = true, },},
}

-- Signals
client.add_signal("manage", function (c, startup)
    awful.client.setslave(c)
    if not startup then
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
client.add_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--// Set cursor theme //--
--exec("xsetroot -cursor_name left_ptr", false)

