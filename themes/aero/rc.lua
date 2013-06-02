require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("vicious")

beautiful.init(awful.util.getdir("config") .. "/theme.lua")

-- Error Handling
if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.add_signal("debug::error", function (err)
      if in_error then return end
      in_error = true
         naughty.notify({ preset = naughty.config.presets.critical,
                          title = "Oops, an error happened!",
                          text = err })
      in_error = false
   end)
end

-- All Settings and Variable goes Here
terminal   = "urxvt"
browser    = "firefox"
editor     = "vim"
fileman    = "thunar"
modkey     = "Mod4"
editor_cmd = terminal .. " -e " .. editor

-- Layout Settings
layouts = 
{
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.fair,
   awful.layout.suit.max,
   awful.layout.suit.floating,
}

-- Tags
local tags = {}
tags =
{
   names = { "eins", "zwei", "drei", "vier", "funf", "sechs", "sieben" }
}

for s = 1, screen.count() do
   tags[s] = awful.tag(tags.names, s, layouts[1])
end

-- Menu
wrentry = {
      { "Terminal"     , terminal               },
      { "File Manager" , fileman                },
      { "Browser"      , browser                },
      { "Logout"       , awesome.quit           },
      { "Restart"      , "gksu reboot"          },
      { "Shut Down"    , "gksu halt"            }}

wrmenu = awful.menu.new({
   bg_normal = beautiful.bg_normal,
   bg_focus  = beautiful.bg_normal,
   border_width = 1,
   items = wrentry })

-- Wibox
wrtopwibox  = {}
wrbotwibox  = {}
wrlayoutbox = {}
wrpromptbox = {}
wrlayoutbox = {}

-- Widget Definition

mpdwidget = widget({ type = "textbox" })
vicious.register(mpdwidget, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return "None Playing"
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

wrsystray = widget({ type = "systray" })

datewidget = widget({ type = "textbox" })
vicious.register(datewidget, vicious.widgets.date, " %a, %Y.%m.%d - %H:%M ", 60)

batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat,
    function (widget, args)
        if args["{state}"] == "Stop" then 
            return "None Playing"
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$2%", 61, "BAT0")

-- Margin
 awful.widget.layout.margins[datewidget] = { top = 1 }
 awful.widget.layout.margins[mpdwidget]  = { top = 1 }
 awful.widget.layout.margins[batwidget]  = { top = 1 }

-- Icon Widget
mpdicon = widget({ type = "imagebox" })
mpdicon.image = image(awful.util.getdir("config") .. "/icons/note.png")

archicon = widget({ type = "imagebox" })
archicon.image = image(awful.util.getdir("config") .. "/icons/arch.png")
archicon:buttons(awful.button({ }, 1, function () 
   if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ 
                                                               bg_normal = beautiful.bg_normal,
                                                               bg_focus  = beautiful.bg_normal,
                                                               border_width = 0,
                                                               width = 300 })
                                              end
                                          end))

clockicon = widget({ type = "imagebox" })
clockicon.image = image(awful.util.getdir("config") .. "/icons/clock.png")

baticon = widget({ type = "imagebox" })
baticon.image = image(awful.util.getdir("config") .. "/icons/battery.png")

separator = widget({ type = "imagebox" })
separator.image = image(awful.util.getdir("config") .. "/icons/separator.png")

separator2 = widget({ type = "imagebox" })
separator2.image = image(awful.util.getdir("config") .. "/icons/separator2.png")

-- Taglist
wrtaglist = {}
wrtaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )

-- Tasklist
wrtasklist = {}
wrtasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))




-- Widget Drawing
for s = 1, screen.count() do
    wrpromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    wrtaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, wrtaglist.buttons)
    wrtasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, wrtasklist.buttons)

    -- Draw the Layoutbox
    wrlayoutbox[s] = awful.widget.layoutbox(s)
    wrlayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
 
    wrtopwibox[s] = awful.wibox({ 
       position = "top",
       screen   = s,
       height   = beautiful.bar_height
    })

    wrtopwibox[s].widgets = {
       { 
        wrlayoutbox[s],
        layout = awful.widget.layout.horizontal.rightleft},
        archicon,
        wrtaglist[s],
        separator2,
        wrpromptbox[s],
        wrtasklist[s],
        layout = awful.widget.layout.horizontal.leftright
    }


    wrbotwibox[s] = awful.wibox({ 
       position = "bottom",
       screen   = s,
       height   = beautiful.bar_height
    })
    wrbotwibox[s].widgets = {
        datewidget,
        clockicon,
        separator,
        batwidget,
        baticon,
        separator,
        mpdwidget,
        mpdicon,
        separator,
        wrsystray,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- Mouse Binding
root.buttons(awful.util.table.join(
   awful.button({ }, 3, function () wrmenu:toggle() end),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
))

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Key Binding
wrkeys = awful.util.table.join(
   awful.key({ }, "Print", function () awful.util.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'") end), 
   awful.key({ modkey, }, "Return", function () awful.util.spawn(terminal) end), 
   awful.key({ modkey, }, "w",      function () wrmenu:show() end),
   awful.key({ modkey, }, "r",      function () wrpromptbox[mouse.screen]:run() end),

   awful.key({ modkey, }, ".", function () awful.tag.incmwfact( 0.05) end),
   awful.key({ modkey, }, ",", function () awful.tag.incmwfact(-0.05) end),

   awful.key({ modkey,         }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),

   awful.key({ modkey, "Shift" }, ".", function () awful.tag.incnmaster( 1) end ),
   awful.key({ modkey, "Shift" }, ",", function () awful.tag.incnmaster(-1) end ),

   awful.key({ modkey, "Shift" }, "Return", function () awful.util.spawn(fileman) end), 
   awful.key({ modkey, "Shift" }, "n",      awful.client.restore),
   awful.key({ modkey, "Shift" }, "r",      awesome.restart),
   awful.key({ modkey, "Shift" }, "q",      awesome.quit),

   awful.key({ modkey, "Shift" }, "Left",  function () awful.client.swap.byidx(-1) end),
   awful.key({ modkey, "Shift" }, "Right", function () awful.client.swap.byidx( 1) end),
 
   awful.key({ modkey, }, "Tab",
   function ()
      awful.client.focus.history.previous()
      if client.focus then
         client.focus:raise()
      end
   end),
 
   awful.key({ modkey, }, "Left",
   function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
   end),
   
   awful.key({ modkey, }, "Right",
   function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
   end))


clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen end),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                       ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop           end),
   awful.key({ modkey,           }, "n",      function (c) c.minimized = true              end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                        end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toogle                    ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:wap(awful.client.getmaster()) end),

   awful.key({ modkey, }, "m",
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c.maximized_vertical   = not c.maximized_vertical
      end)
)

-- Keynumber Binding
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
   wrkeys = awful.util.table.join(wrkeys,
      awful.key({ modkey }, "#" .. i + 9,
         function ()
            local screen = mouse.screen
            if tags[screen][i] then
               awful.tag.viewonly(tags[screen][i])
            end
         end),
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
         function ()
            if client.focus and tags[client.focus.screen][i] then
               awful.client.movetotag(tags[client.focus.screen][i])
            end
         end))
end

-- Load the Keys
root.keys(wrkeys)

-- Rules
awful.rules.rules = {
   { rule = { },
     properties = { border_width     = beautiful.border_width,
                    border_color     = beautiful.border_normal,
                    focus            = true,
                    keys             = clientkeys,
                    buttons          = clientbuttons,
                     size_hints_honor = false} },
}

-- Signals
client.add_signal("manage", function (c, startup)
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
