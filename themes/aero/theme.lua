theme = {}
confdir = awful.util.getdir("config")

theme.font          = "terminus 8"

theme.bg_normal     = "#19171c"
theme.bg_focus      = "#00000000"
theme.bg_urgent     = theme.bg_focus
theme.bg_minimize   = theme.bg_focus
theme.bg_systray    = theme.bg_focus

theme.fg_normal     = "#ffffff"
theme.fg_focus      = "#cb1456"
theme.fg_urgent     = theme.fg_focus
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 1
theme.border_normal = "#29262e"
theme.border_focus  = theme.fg_focus
theme.border_marked = theme.border_focus


theme.bar_height  = 20
theme.menu_height = 18
theme.menu_width  = 120

-- Icon Settings
theme.layout_tile = confdir .. "/layouts/tile.png"
theme.layout_tileleft = confdir .. "/layouts/tileleft.png"
theme.layout_fairv = confdir .. "/layouts/fairv.png"
theme.layout_max = confdir .. "/layouts/max.png"
theme.layout_floating = confdir .. "/layouts/floating.png"

theme.wallpaper_cmd = { "~/.fehbg" }
theme.icon_theme = nil

return theme
