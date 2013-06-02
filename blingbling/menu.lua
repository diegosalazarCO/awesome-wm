---------------------------------------------------------------------------
-- Original module created by:
-- Damien Leone &lt;damien.leone@gmail.com&gt;
-- Julien Danjou &lt;julien@danjou.info&gt;
-- copyright 2008 Damien Leone, Julien Danjou
-- release v3.4.10
---------------------------------------------------------------------------
--Modified by : cedlemo cedlemo at gmx dot com
--Modifications:
--add width adjustement:
----first menu take width given by user, if entries label is longer then width is adjusted.
----width for submenu is auto-adjusted
--add id value for each menu (first menu id=0, second generated menu id =1 etc ..)
----Todo: use id to allow user to fix width for each submenu or to allow user to customize each submenu.

-- Grab environment we need
local pairs = pairs
local ipairs = ipairs
local table = table
local string = string
local type = type
local setmetatable = setmetatable
local wibox = wibox
local image = image
local widget = widget
local button = require("awful.button")
local capi =
{
    screen = screen,
    mouse = mouse,
    client = client,
    keygrabber = keygrabber
}
local util = require("awful.util")
local tags = require("awful.tag")
local layout = require("awful.widget.layout")
local awbeautiful = require("beautiful")
local tonumber = tonumber
local helpers=require("blingbling.helpers")
--- Creation of menus with auto-adjusted width.
module("blingbling.menu")

local cur_menu

--- Key bindings for menu navigation.
-- Keys are: up, down, exec, back, close. Value are table with a list of valid
-- keys for the action, i.e. menu_keys.up =  { "j", "k" } will bind 'j' and 'k'
-- key to up action. This is common to all created menu.
-- @class table
-- @name menu_keys
menu_keys = { up = { "Up" },
              down = { "Down" },
              exec = { "Return", "Right" },
              back = { "Left" },
              close = { "Escape" } }

local function load_theme(custom)
    local theme = {}
    local beautiful

    beautiful = awbeautiful.get()

    theme.fg_focus = custom.fg_focus or beautiful.menu_fg_focus or beautiful.fg_focus
    theme.bg_focus = custom.bg_focus or beautiful.menu_bg_focus or beautiful.bg_focus
    theme.fg_normal = custom.fg_normal or beautiful.menu_fg_normal or beautiful.fg_normal
    theme.bg_normal = custom.bg_normal or beautiful.menu_bg_normal or beautiful.bg_normal

    theme.submenu_icon = custom.submenu_icon or beautiful.menu_submenu_icon

    theme.menu_height = custom.height or beautiful.menu_height or 16
    theme.menu_width = custom.width or beautiful.menu_width or 100

    theme.border = custom.border_color or beautiful.menu_border_color or beautiful.border_normal
    theme.border_width = custom.border_width or beautiful.menu_border_width or beautiful.border_width

    return theme
end

local function item_leave(menu, num)
    if num > 0 then
        menu.items[num].wibox.fg = menu.theme.fg_normal
        menu.items[num].wibox.bg = menu.theme.bg_normal
    end
end

--- Hide a menu popup.
-- @param menu The menu to hide.
function hide(menu)
    -- Remove items from screen
    for i = 1, #menu.items do
        item_leave(menu, i)
        menu.items[i].wibox.screen = nil
    end
    if menu.active_child then
        menu.active_child:hide()
        menu.active_child = nil
    end
    menu.sel = nil

    if cur_menu == menu then
        cur_menu = cur_menu.parent
    end
    if not cur_menu and menu.keygrabber then
        capi.keygrabber.stop()
    end
end

-- Get the elder parent so for example when you kill
-- it, it will destroy the whole family.
local function get_parents(menu)
    if menu.parent then
        return get_parents(menu.parent)
    end
    return menu
end

local function exec(menu, num, mouse_event)
    local cmd = menu.items[num].cmd
    if type(cmd) == "table" then
        if #cmd == 0 then
            return
        end
        if not menu.child[num] then
            menu.child[num] = new({ items = cmd }, menu, num)
        end

        if menu.active_child then
            menu.active_child:hide()
            menu.active_child = nil
        end
        menu.active_child = menu.child[num]
        menu.active_child:show()
    elseif type(cmd) == "string" then
        get_parents(menu):hide()
        util.spawn(cmd)
    elseif type(cmd) == "function" then
        get_parents(menu):hide()
        cmd(menu.items[num].returned_value)
    end
end

local function item_enter(menu, num, mouse_event)
    if menu.sel == num then
        return
    elseif menu.sel then
        item_leave(menu, menu.sel)
    end

    menu.items[num].wibox.fg = menu.theme.fg_focus
    menu.items[num].wibox.bg = menu.theme.bg_focus
    menu.sel = num
    cur_menu = menu

    if menu.auto_expand and mouse_event then
        if menu.active_child then
            menu.active_child:hide()
            menu.active_child = nil
        end

        if type(menu.items[num].cmd) == "table" then
            exec(menu, num)
        end
    end
end

local function check_access_key(menu, key)
   for i, item in pairs(menu.items) do
      if item.akey == key then
          item_enter(menu, i)
          exec(menu, i)
          return
      end
   end
   if menu.parent then
      check_access_key(menu.parent, key)
   end
end

local function grabber(mod, key, event)
    if event == "release" then
       return true
    end

    local sel = cur_menu.sel or 0
    if util.table.hasitem(menu_keys.up, key) then
        local sel_new = sel-1 < 1 and #cur_menu.items or sel-1
        item_enter(cur_menu, sel_new)
    elseif util.table.hasitem(menu_keys.down, key) then
        local sel_new = sel+1 > #cur_menu.items and 1 or sel+1
        item_enter(cur_menu, sel_new)
    elseif sel > 0 and util.table.hasitem(menu_keys.exec, key) then
        exec(cur_menu, sel)
    elseif util.table.hasitem(menu_keys.back, key) then
        cur_menu:hide()
    elseif util.table.hasitem(menu_keys.close, key) then
        get_parents(cur_menu):hide()
    else
        check_access_key(cur_menu, key)
    end
   
    return true
end

local function add_item(data, num, item_info)
    local item = wibox({
        fg = data.theme.fg_normal,
        bg = data.theme.bg_normal,
        border_color = data.theme.border,
        border_width = data.theme.border_width
    })

    -- Create bindings
    local bindings = util.table.join(
        button({}, 1, function () item_enter(data, num); exec(data, num) end),
        button({}, 3, function () data:hide() end)
    )

    -- Create the item label widget
    local label = widget({ type = "textbox" })
    local key = ''
    label.text = string.gsub(util.escape(item_info[1]), "&amp;(%w)",
                             function (l)
                                 key = string.lower(l)
                                 return "<u>"..l.."</u>"
                             end, 1)  
    -- Set icon if needed
    local iconbox
    if item_info[3] then
        local icon = type(item_info[3]) == "string" and image(item_info[3]) or item_info[3]
        if icon.width > data.h or icon.height > data.h then
            local width, height
            if ((data.h/icon.height) * icon.width) > data.h then
                width, height = data.h, (data.h / icon.width) * icon.height
            else
                width, height = (data.h / icon.height) * icon.width, data.h
            end
            icon = icon:crop_and_scale(0, 0, icon.width, icon.height, width, height)
        end
        iconbox = widget { type = "imagebox" }
        iconbox.image = icon
        layout.margins[label] = { left = 2 }
    else
        layout.margins[label] = { left = data.h + 2 }
    end

    item:buttons(bindings)

    local mouse_enter_func = function () item_enter(data, num, true) end
    item:add_signal("mouse::enter", mouse_enter_func)

    -- Create the submenu icon widget
    local submenu
    if type(item_info[2]) == "table" then
        submenu = widget({ type = "imagebox" })
        submenu.image = data.theme.submenu_icon and image(data.theme.submenu_icon)
        submenu:buttons(bindings)
    end

    -- Add widgets to the wibox
    if iconbox then
        item.widgets = {
            iconbox,
            label,
            { submenu, layout = layout.horizontal.rightleft },
            layout = layout.horizontal.leftright
        }
    else
        item.widgets = {
            label,
            { submenu, layout = layout.horizontal.rightleft },
            layout = layout.horizontal.leftright
        }
    end

    item.height = label:extents().height + 2
    item.width = label:extents().width + (data.h + 2)*2
    item.ontop = true

    return { wibox = item, akey= key, cmd = item_info[2], returned_value=item_info[1] }
end

--- Build a popup menu with running clients and shows it.
-- @param menu Menu table, see new() function for more informations
-- @param args.keygrabber A boolean enabling or not the keyboard navigation.
-- @return The menu.
function clients(menu, args)
    local cls = capi.client.get()
    local cls_t = {}
    for k, c in pairs(cls) do
        cls_t[#cls_t + 1] = { util.escape(c.name) or "",
                              function ()
                                  if not c:isvisible() then
                                      tags.viewmore(c:tags(), c.screen)
                                  end
                                  capi.client.focus = c
                                  c:raise()
                              end,
                              c.icon }
    end

    if not menu then
        menu = {}
    end

    menu.items = cls_t

    local m = new(menu)
    m:show(args)
    return m
end

local function set_coords(menu, screen_idx, m_coords)
    local s_geometry = capi.screen[screen_idx].workarea
    local screen_w = s_geometry.x + s_geometry.width
    local screen_h = s_geometry.y + s_geometry.height

    local i_h = menu.h + menu.theme.border_width
    local m_h = (i_h * #menu.items) + menu.theme.border_width

    if menu.parent then

        local p_w = i_h * (menu.num - 1)
        local m_w = menu.parent.w - menu.theme.border_width
        
        menu.y = menu.parent.y + p_w + m_h > screen_h and screen_h - m_h or menu.parent.y + p_w
        if menu.parent.x + m_w + menu.w < screen_w and menu.parent.right_to_left == false then
            menu.x=menu.parent.x + m_w
            menu.right_to_left = false
        else
            menu.x=menu.parent.x + menu.theme.border_width -(menu.w)
            menu.right_to_left = true
        end
    else
        local m_w = menu.w
        if m_coords == nil then
            m_coords = capi.mouse.coords()
            m_coords.x = m_coords.x + 1
            m_coords.y = m_coords.y + 1
        end

        menu.y = m_coords.y < s_geometry.y and s_geometry.y or m_coords.y
        menu.x = m_coords.x < s_geometry.x and s_geometry.x or m_coords.x

        menu.y = menu.y + m_h > screen_h and screen_h - m_h or menu.y
        menu.x = menu.x + m_w > screen_w and screen_w - m_w or menu.x
    end
end

--- Show a menu.
-- @param menu The menu to show.
-- @param args.keygrabber A boolean enabling or not the keyboard navigation.
-- @param args.coords Menu position defaulting to mouse.coords()
function show(menu, args)
    args = args or {}
    local screen_index = capi.mouse.screen
    local keygrabber = args.keygrabber or false
    local coords = args.coords or nil
    set_coords(menu, screen_index, coords)
    for num, item in pairs(menu.items) do
        local wibox = item.wibox
        wibox.width = menu.w
        wibox.height = menu.h
        wibox.x = menu.x
        wibox.y = menu.y + (num - 1) * (menu.h + wibox.border_width)
        wibox.screen = screen_index
    end

    if menu.parent then
        menu.keygrabber = menu.parent.keygrabber
    elseif keygrabber ~= nil then
        menu.keygrabber = keygrabber
    else
        menu.keygrabber = false
    end

    if not cur_menu and menu.keygrabber then
        capi.keygrabber.run(grabber) 
    end
    cur_menu = menu
end

--- Toggle menu visibility.
-- @param menu The menu to show if it's hidden, or to hide if it's shown.
-- @param args.keygrabber A boolean enabling or not the keyboard navigation.
-- @param args.coords Menu position {x,y}
function toggle(menu, args)
    if menu.items[1] and menu.items[1].wibox.screen then
        menu:hide()
    else
        menu:show(args)
    end
end

--- Open a menu popup.
-- @param menu Table containing the menu informations.<br/>
-- <ul>
-- <li> Key items: Table containing the displayed items. Each element is a table containing: item name, triggered action, submenu table or function, item icon (optional). </li>
-- <li> Keys [fg|bg]_[focus|normal], border, border_width, submenu_icon, height and width override the default display for your menu, each of them are optional. </li>
-- <li> Key auto_expand controls the submenu auto expand behaviour by setting it to true (default) or false. </li>
-- </ul>
-- @param parent Specify the parent menu if we want to open a submenu, this value should never be set by the user.
-- @param num Specify the parent's clicked item number if we want to open a submenu, this value should never be set by the user.

function new(menu, parent, num, id)
    -- Create a table to store our menu informations
    local data = {}
    data.id = parent and (parent.id + 1) or 0
    data.items = {}
    data.num = num or 1
    data.theme = parent and parent.theme or load_theme(menu)
    data.parent = parent
    data.child = {}
    data.right_to_left = false
    if parent then
        data.auto_expand = parent.auto_expand
    elseif menu.auto_expand ~= nil then
        data.auto_expand = menu.auto_expand
    else
        data.auto_expand = true
    end
    data.h = parent and parent.h or data.theme.menu_height
    if type(data.h) ~= 'number' then data.h = tonumber(data.h) end

    -- Create items
    for k, v in pairs(menu.items) do
        table.insert(data.items, add_item(data, k, v))
    end

    if #data.items > 0 and data.h < data.items[1].wibox.height then
        data.h = data.items[1].wibox.height
    end
    --if a submenu, find the bigger width of item to adjust the menu width
    local bigger_width=0
    for i,v in ipairs(data.items) do
      if bigger_width < v.wibox.width then
         bigger_width = v.wibox.width
      end
    end
    
    if data.id > 0 then
        --for submenu width depends on the longer label
        for i,v in ipairs(data.items) do
          if bigger_width < v.wibox.width then
            bigger_width = v.wibox.width
          end
        end
       data.w = bigger_width
   else
       --define first menu width
       if tonumber(data.theme.menu_width) > bigger_width then
         data.w = data.theme.menu_width
       else
         data.w = bigger_width
       end
   end
    
    -- Set methods
    data.hide = hide
    data.show = show
    data.toggle = toggle

    return data
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

