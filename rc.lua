--[[
TODO

- multiple monitors
  - `screen:count()` tells you how many screen it has
  - `awful.screen.focused()` returns a `screen` instance of the focused screen
  - `awful.screen.focus(s: screen)`: moves the focus to `s`
  - if `s` is a `screen` instance,
    - `s.index`: an integer starting with 1
    - `s.tags`: a read-only list of all tags on `s`
  - if `t` is a `tag` instance
    - `t.screen`: a `screen` instance where `t` belongs to

]]--

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
-- pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local polybar_on = true

curr_tag = 0

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

HOME = "/home/baehyunsol"

-- Themes
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

beautiful.useless_gap = dpi(4)
beautiful.border_width = dpi(2)
beautiful.border_focus = "#f02020"
beautiful.border_none = "#404040"
beautiful.wallpaper = string.format("%s/Downloads/bg.png", HOME)

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,  -- TODO: set the ratio of windows to 6:4 by default
    awful.layout.suit.tile.bottom,
}

-- start-up applications
local function launch_polybar ()
    awful.spawn(string.format("polybar -c %s/.config/polybar.ini bar0", HOME))
    awful.spawn(string.format("polybar -c %s/.config/polybar.ini bar1", HOME))
    awful.spawn(string.format("polybar -c %s/.config/polybar.ini bar2", HOME))
    awful.spawn(string.format("polybar -c %s/.config/polybar.ini bar3", HOME))
end

awful.spawn("picom -i 0.88")
launch_polybar()
-- awful.spawn(string.format("%s/.config/_init/init.py", HOME))  -- not using these scripts anymore...
awful.spawn("pueued")

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, s, awful.layout.layouts[1])

    -- set default ratio of windows to 64:36
    for i = 1, 10 do
        s.tags[i].master_width_factor = 0.64
    end
end)

all_tags = root.tags()

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- view previous
    awful.key({ modkey }, "Left", function ()
        awful.tag.viewprev()
        curr_tag = (curr_tag + 9) % 10
    end),

    -- view next
    awful.key({ modkey }, "Right", function ()
        awful.tag.viewnext()
        curr_tag = (curr_tag + 1) % 10
    end),

    -- move client to the previous tag
    awful.key({ modkey, "Control" }, "Left", function ()
        if client.focus then
            curr_tag = (curr_tag + 9) % 10
            local tag = client.focus.screen.tags[curr_tag]

            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end),

    -- move client to the next tag
    awful.key({ modkey, "Control" }, "Right", function ()
        if client.focus then
            curr_tag = (curr_tag + 1) % 10
            local tag = client.focus.screen.tags[curr_tag]

            if tag then
                client.focus:move_to_tag(tag)
            end
        end
    end),

    -- focus next client
    awful.key({ modkey }, "Down", function ()
        awful.client.focus.byidx(1)

        if client.focus ~= nil then
            mouse.coords {
                x = client.focus.x + client.focus.width / 2,
                y = client.focus.y + client.focus.height / 2,
            }
        end

    end),

    -- focus previous client
    awful.key({ modkey }, "Up", function ()
        awful.client.focus.byidx(-1)

        if client.focus ~= nil then
            mouse.coords {
                x = client.focus.x + client.focus.width / 2,
                y = client.focus.y + client.focus.height / 2,
            }
        end

    end),

    -- Layout manipulation

    -- move client down
    awful.key({ modkey, "Control" }, "Down", function () awful.client.swap.byidx(1) end),

    -- move client up
    awful.key({ modkey, "Control" }, "Up", function () awful.client.swap.byidx(-1) end),

    -- toggle polybar
    awful.key({ modkey, "Control" }, "p", function ()
        if polybar_on then
            awesome.spawn("pkill polybar")
            polybar_on = false
        else
            launch_polybar()
            polybar_on = true
        end
    end),

    -- restart awesome
    awful.key({ modkey, "Control" }, "r", function ()
        awesome.spawn("pkill polybar")
        awesome.spawn("pkill picom")
        -- awesome.spawn(string.format("%s/.config/_init/lock.py", HOME))  -- not using these scripts anymore...
        curr_tag = 1
        awesome.restart()
    end),

    -- kill awesome
    awful.key({ modkey, "Control" }, "x", function ()
        awesome.spawn("pkill polybar")
        awesome.spawn("pkill picom")
        awesome.quit()
    end),

    -- make the main window wider
    awful.key({ modkey, "Control" }, "w", function () awful.tag.incmwfact( 0.05) end),

    -- make the main window narrower
    awful.key({ modkey, "Control" }, "n", function () awful.tag.incmwfact(-0.05) end),

    -- select next layout
    awful.key({ modkey }, "space", function () awful.layout.inc(1) end),

    -- Launch applications/utilities
    awful.key({ modkey }, "r", function () awful.spawn("rofi -show run") end),

    awful.key({ modkey, "Shift" }, "Return", function () awful.spawn("alacritty") end),
    awful.key({ modkey, "Shift", "Control" }, "Return", function () awful.spawn("alacritty --class FloatSmall") end),

    awful.key({ modkey, "Shift" }, "h", function () awful.spawn(string.format("brave-browser --new-window %s/Documents/DThelp/index.html", HOME)) end),
    awful.key({ modkey, "Shift", "Control" }, "h", function () awful.spawn(string.format("brave-browser --class=FloatMedium --new-window %s/Documents/DThelp/index.html", HOME)) end),

    -- for now, the control center doesn't work with awesome, I need a walk-around
    awful.key({ modkey, "Shift" }, "c", function () awful.spawn("env XDG_CURRENT_DESKTOP=GNOME gnome-control-center") end),  -- TODO: remove GNOME

    awful.key({ modkey, "Shift" }, "w", function () awful.spawn("brave-browser") end),
    awful.key({ modkey, "Shift", "Control" }, "w", function () awful.spawn("brave-browser --class=FloatMedium") end),

    awful.key({ modkey, "Shift" }, "i", function () awful.spawn("brave-browser --incognito") end),
    awful.key({ modkey, "Shift", "Control" }, "i", function () awful.spawn("brave-browser --incognito --class=FloatMedium") end),

    awful.key({ modkey, "Shift" }, "v", function () awful.spawn("code") end),
    awful.key({ modkey, "Shift" }, "n", function () awful.spawn("nautilus") end),  -- TODO: remove GNOME

    awful.key({ modkey, "Shift" }, "m", function () awful.spawn("gedit") end),
    awful.key({ modkey, "Shift", "Control" }, "m", function () awful.spawn("gedit --class=FloatSmall") end),

    awful.key({ modkey, "Shift" }, "p", function () awful.spawn("alacritty --command python3 -i -c \"from math import *\"") end),
    awful.key({ modkey, "Shift", "Control" }, "p", function () awful.spawn("alacritty --class FloatSmall --command python3 -i -c \"from math import *\"") end),

    awful.key({ modkey, "Shift" }, "s", function () awful.spawn("alacritty --command btm --battery") end),
    awful.key({ modkey, "Shift", "Control" }, "s", function () awful.spawn("alacritty --class FloatBig --command btm --battery") end),

    awful.key({ modkey, "Shift" }, "F1", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"screenshot\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F2", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"screenshot all\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F3", function () awful.spawn(string.format("vlc --random %s/Music", HOME)) end),
    awful.key({ modkey, "Shift" }, "F4", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"br0\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F5", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"br1\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F6", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"br2\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F7", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"br3\"", HOME)) end),
    awful.key({ modkey, "Shift" }, "F8", function () awful.spawn(string.format("%s/.config/nushell/funcs.nu \"br4\"", HOME)) end)
)

clientkeys = gears.table.join(
    -- toggle fullscreen
    awful.key({ modkey, "Control" }, "f",
        function (c)

            -- trick: when a window is not obeying the rules, try `Mod+Control+F`. i don't know why, but it fixes
            c.maximized = false
            c.minimized = false

            c.fullscreen = not c.fullscreen
            c:raise()
        end),

    -- kill client
    awful.key({ modkey, "Control" }, "q", function (c) c:kill() end),

    -- toggle floating
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle),

    -- toggle always on top
    awful.key({ modkey, "Control" }, "t", function (c) c.ontop = not c.ontop end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                curr_tag = i
                local screen = awful.screen.focused()
                local tag = screen.tags[i]

                if tag then
                    tag:view_only()
                end
            end),
        -- Move client to tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    curr_tag = i

                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end
        )
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 2, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.client.floating.toggle()
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

function floating_window(class, offset, w, h)
    return {
        rule = { class = class },
        properties = {
            x = offset,
            y = offset,
            width = w,
            height = h,
            floating = true,
            ontop = true
        }
    }
end

    -- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,

            -- most windows are not launced maximized, except libreoffice. this line is to prevent libreoffice from launched maximized
            maximized = false,
            maximized_horizontal = false,
            maximized_verical = false,

            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    -- TODO: make it proportional to the size of the display
    floating_window("FloatSmall", 80, 540, 540),
    floating_window("FloatMedium", 80, 720, 720),
    floating_window("FloatBig", 100, 1200, 800)

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    -- move mouse to the center when ta new client is launched
    mouse.coords {
        x = c.x + c.width / 2,
        y = c.y + c.height / 2
    }

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    if c.class ~= "Polybar" then
        c.border_color = beautiful.border_focus
    end
end)
client.connect_signal("unfocus", function(c)
    if c.class ~= "Polybar" then
        c.border_color = beautiful.border_none
    end
end)
-- }}}