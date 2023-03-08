#!/home/baehyunsol/.cargo/bin/nu
let disp = (xrandr | into string | split row "\n" | find " connected" | get 0 | split row " " | get 0);

xrandr --output $disp --brightness 0.1
