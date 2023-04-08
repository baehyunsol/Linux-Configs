#!/home/baehyunsol/.cargo/bin/nu

xrandr | into string | split row "\n" | find " connected" | each {|x| split row " " | get 0} | each {|x| xrandr --output $x --brightness 0.05}
