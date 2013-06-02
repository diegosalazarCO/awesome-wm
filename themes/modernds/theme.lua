--------------------------------
--  "ModernDs" awesome theme  --
--     By Daes DP. (2011)     --
--------------------------------

-- Main---------------------------------------------------------------------------------------------
theme = {}
pwd = awful.util.pread("echo $HOME"):gsub("\n", "")
theme.wallpaper_cmd = { 'awsetbg -f ' .. pwd .. 
'/.config/awesome/themes/default/diamond_wallpaper.jpg' }
----------------------------------------------------------------------------------------------------

-- Styles --------------------
theme.font      = "Terminus 8"
------------------------------

-- Colors -------------------
theme.fg_normal = "#7786a3"
theme.fg_focus  = "#99a9cf"
theme.fg_urgent = "#99c4cf"
theme.bg_normal = "#151515f0"
theme.bg_focus  = ""
theme.bg_urgent = ""
-----------------------------

-- Borders ---------------------
theme.border_width  = "1"
theme.border_panel = "#050505"
theme.border_normal = "#151515"
theme.border_wnormal = "#303030"
--------------------------------

-- Menu -----------------
theme.menu_height = "15"
theme.menu_width  = "100"
-------------------------

-- Taglist ---------------------------------------------------------------------------
theme.taglist_squares_sel   = "~/.config/awesome/themes/modernds/taglist/squarefw.png"
theme.taglist_squares_unsel = "~/.config/awesome/themes/modernds/taglist/squarew.png"
--------------------------------------------------------------------------------------

-- Misc ----------------------------------------------------------------------------
theme.menu_submenu_icon      = "~/.config/awesome/themes/modernds/icons/submenu.png"
theme.awesome_icon           = "~/.config/awesome/themes/modernds/icons/awesome-icon.png"
------------------------------------------------------------------------------------

-- Layout --------------------------------------------------------------------------
theme.layout_fairh           = "~/.config/awesome/themes/modernds/layouts/fairh.png"
theme.layout_fairv           = "~/.config/awesome/themes/modernds/layouts/fairv.png"
theme.layout_floating        = "~/.config/awesome/themes/modernds/layouts/floating.png"
theme.layout_magnifier       = "~/.config/awesome/themes/modernds/layouts/magnifier.png"
theme.layout_max             = "~/.config/awesome/themes/modernds/layouts/max.png"
theme.layout_fullscreen      = "~/.config/awesome/themes/modernds/layouts/fullscreen.png"
theme.layout_tilebottom      = "~/.config/awesome/themes/modernds/layouts/tilebottom.png"
theme.layout_tileleft        = "~/.config/awesome/themes/modernds/layouts/tileleft.png"
theme.layout_tile            = "~/.config/awesome/themes/modernds/layouts/tile.png"
theme.layout_tiletop         = "~/.config/awesome/themes/modernds/layouts/tiletop.png"
theme.layout_spiral          = "~/.config/awesome/themes/modernds/layouts/spiral.png"
theme.layout_dwindle         = "~/.config/awesome/themes/modernds/layouts/dwindle.png"
------------------------------------------------------------------------------------

return theme
