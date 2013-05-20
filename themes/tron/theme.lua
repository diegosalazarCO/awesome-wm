-- 				        --
--		[Tron Theme]		--
--		[by Kirafreaky]		--
--					--
					
-- [ Main

theme = {}
theme.confdir = os.getenv("HOME") .. "/.config/awesome/themes/tron"

--[ Wallpaper

theme.wallpaper = theme.confdir .. "/tron_light_cycle_run.png"
--theme.wallpaper = theme.confdir .. "/tron_city.jpg"
--theme.wallpaper = theme.confdir .. "/blue_robot_wallpaper.jpg"
--theme.wallpaper = theme.confdir .. "/glowing_balls.jpg"
-- ]

-- [ Font

theme.font      = "tamsyn 12"

-- ]

-- [ Colors

-- theme.bg_systray = theme.bg_normal

theme.bg_normal     = "#080808"
theme.bg_focus      = "#080808"
theme.bg_urgent     = "#080808"
theme.bg_minimize   = "#080808"

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#2fffdc"
theme.fg_urgent     = "#b93aff"
theme.fg_minimize   = "#444444"

theme.fg_black      = "#424242"
theme.fg_red        = "#ff2f4b"
theme.fg_green      = "#2fff8f"
theme.fg_yellow     = "#ffaf5f"
theme.fg_blue       = "#36cdff"
theme.fg_magenta    = "#b93aff"
theme.fg_cyan       = "#2fffdc"
theme.fg_white      = "#aaaaaa"
theme.fg_blu        = "#669997"

-- ]

-- [ Borders

theme.border_width  = 1
theme.border_normal = "#202020"
theme.border_focus  = "#339dff"
theme.border_marked = "#91231c"

-- ]

-- [ Menu Config

theme.menu_height       = "15"
theme.menu_width        = "105"
theme.menu_border_width = "0"
theme.menu_fg_normal    = "#aaaaaa"   --color txt pip
theme.menu_fg_focus     = "#2fffdc"
theme.menu_bg_normal    = "#080808"   --background menu
theme.menu_bg_focus     = "#080808"

-- ]

-- [ Icons

theme.widget_uptime     = theme.confdir .. "/widgets/magenta/ac_01.png"
theme.widget_cpu        = theme.confdir .. "/widgets/Ultimate/cpu.png"
theme.widget_temp       = theme.confdir .. "/widgets/yellow/temp.png"
theme.widget_mem        = theme.confdir .. "/widgets/Ultimate/mem.png"
theme.widget_fs         = theme.confdir .. "/widgets/cyan/usb.png"
theme.widget_netdown    = theme.confdir .. "/widgets/Ultimate/net_down_02.png"
theme.widget_netup      = theme.confdir .. "/widgets/Ultimate/net_up_02.png"
theme.widget_gmail      = theme.confdir .. "/widgets/magenta/mail.png"
theme.widget_sys        = theme.confdir .. "/widgets/green/dish.png"
theme.widget_pac        = theme.confdir .. "/widgets/green/pacman.png"
theme.widget_batt       = theme.confdir .. "/widgets/Ultimate/bat.png"
theme.widget_clock      = theme.confdir .. "/widgets/Ultimate/clock.png"
theme.widget_vol        = theme.confdir .. "/widgets/Ultimate/vol.png"
theme.widget_mpd	= theme.confdir .. "/widgets/Ultimate/play.png"
theme.widget_wifi	= theme.confdir .. "/widgets/Ultimate/wifi_01.png"
-- ]

-- [ Taglist

theme.taglist_squares_sel   = theme.confdir .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.confdir .. "/taglist/square_b.png"

--theme.taglist_squares_resize = "false"

-- ]

-- [ Misc

theme.tasklist_floating_icon = theme.confdir .. "/floating.png"

-- ]

-- [ Layout

theme.layout_tile       = theme.confdir .. "/layouts2/tile.png"
theme.layout_tileleft   = theme.confdir .. "/layouts2/tileleft.png"
theme.layout_tilebottom = theme.confdir .. "/layouts2/tilebottom.png"
theme.layout_tiletop    = theme.confdir .. "/layouts2/tiletop.png"
theme.layout_fairv      = theme.confdir .. "/layouts2/fairv.png"
theme.layout_fairh      = theme.confdir .. "/layouts2/fairh.png"
theme.layout_spiral     = theme.confdir .. "/layouts2/spiral.png"
theme.layout_dwindle    = theme.confdir .. "/layouts2/dwindle.png"
theme.layout_max        = theme.confdir .. "/layouts2/max.png"
theme.layout_fullscreen = theme.confdir .. "/layouts2/fullscreen.png"
theme.layout_magnifier  = theme.confdir .. "/layouts2/magnifier.png"
theme.layout_floating   = theme.confdir .. "/layouts2/floating.png"

-- ]

-- [ Menu Icons
theme.menu_submenu_icon = theme.confdir .. "/submenu.png"
theme.awesome_icon = theme.confdir .. "/arch_blue.png"
-- ]

return theme

-- ]
