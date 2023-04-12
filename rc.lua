-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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

-- Themes
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

beautiful.useless_gap = dpi(4)
beautiful.border_width = dpi(2)
beautiful.border_focus = "#f02020"
beautiful.border_none = "#404040"
beautiful.wallpaper = "/home/baehyunsol/Downloads/bg.jpg"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}

-- start-up applications
awful.spawn("picom -i 0.88")
awful.spawn("polybar -c /home/baehyunsol/.config/polybar.ini bar0")
awful.spawn("polybar -c /home/baehyunsol/.config/polybar.ini bar1")
awful.spawn("polybar -c /home/baehyunsol/.config/polybar.ini bar2")
awful.spawn("polybar -c /home/baehyunsol/.config/polybar.ini bar3")
awful.spawn("/home/baehyunsol/.config/_init/init.py")

floating_window_size = 480

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
end)

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- view previous
    awful.key({ modkey }, "Left", awful.tag.viewprev),

    -- view next
    awful.key({ modkey }, "Right", awful.tag.viewnext),

    -- focus next client
    awful.key({ modkey }, "Down", function ()
        awful.client.focus.byidx(1)
        mouse.coords {
            x = client.focus.x + client.focus.width / 2,
            y = client.focus.y + client.focus.height / 2
        }
    end),

    -- focus previous client
    awful.key({ modkey }, "Up", function ()
        awful.client.focus.byidx(-1)
        mouse.coords {
            x = client.focus.x + client.focus.width / 2,
            y = client.focus.y + client.focus.height / 2
        }
    end),

    -- Layout manipulation

    -- move client down
    awful.key({ modkey, "Control" }, "Down", function () awful.client.swap.byidx(1) end),

    -- move client up
    awful.key({ modkey, "Control" }, "Up", function () awful.client.swap.byidx(-1) end),

    -- restart awesome
    awful.key({ modkey, "Control" }, "r", function ()
        awesome.spawn("pkill polybar")
        awesome.spawn("pkill picom")
        awesome.spawn("/home/baehyunsol/.config/_init/lock.py")  -- makes sure that the init script is not launched
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
    awful.key({ modkey, "Shift" }, "h", function () awful.spawn("firefox --new-window /home/baehyunsol/Documents/DThelp/index.html") end),
    awful.key({ modkey, "Shift" }, "c", function () awful.spawn("gnome-control-center") end),
    awful.key({ modkey, "Shift" }, "f", function () awful.spawn("firefox") end),
    awful.key({ modkey, "Shift" }, "p", function () awful.spawn("firefox --private-window") end),
    awful.key({ modkey, "Shift" }, "v", function () awful.spawn("code") end),
    awful.key({ modkey, "Shift" }, "n", function () awful.spawn("nautilus") end),
    awful.key({ modkey, "Shift" }, "m", function () awful.spawn("gnome-text-editor") end),
    awful.key({ modkey, "Shift" }, "l", function () awful.spawn("gnome-calculator") end),
    awful.key({ modkey, "Shift" }, "y", function () awful.spawn("gnome-system-monitor -p") end),

    awful.key({ modkey, "Shift" }, "F1", function () awful.spawn("/home/baehyunsol/.config/nushell/funcs.nu \"screenshot\"") end),
    awful.key({ modkey, "Shift" }, "F2", function () awful.spawn("/home/baehyunsol/.config/nushell/funcs.nu \"screenshot all\"") end),
    awful.key({ modkey, "Shift" }, "F3", function () awful.spawn("vlc --random /home/baehyunsol/Music") end),
    awful.key({ modkey, "Shift" }, "F4", function () awful.spawn("/home/baehyunsol/.config/nushell/funcs.nu \"turn black\"") end),
    awful.key({ modkey, "Shift" }, "F5", function () awful.spawn("/home/baehyunsol/.config/nushell/funcs.nu \"turn white\"") end)
)

clientkeys = gears.table.join(
    -- toggle fullscreen
    awful.key({ modkey, "Control" }, "f",
        function (c)
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
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end)
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
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

function floating_window(class, offset)
    return {
        rule = { class = class },
        properties = {
            x = offset,
            y = offset,
            width = floating_window_size,
            height = floating_window_size,
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
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    floating_window("gnome-text-editor", 60),
    floating_window("gnome-calculator", 80),
    floating_window("Gnome-system-monitor", 100)  -- why the hell are they using mixed characters?

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

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

-- move mouse to the center when a new client is launched
client.connect_signal("manage", function(c)
    mouse.coords {
        x = c.x + c.width / 2,
        y = c.y + c.height / 2
    }
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
