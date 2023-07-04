#!/home/baehyunsol/.cargo/bin/nu

def main [action: string, extra_arg: string = ""] {
    if $action == "turn black" {  # turn black
        xrandr | into string | lines | find " connected" | each {|x| split row " " | get 0} | each {|x| xrandr --output $x --brightness 0.05}
    } else if $action == "turn white" { # turn white
        xrandr | into string | lines | find " connected" | each {|x| split row " " | get 0} | each {|x| xrandr --output $x --brightness 1.0}
    } else if $action == "screenshot" {
        let now = (date now | date to-table);
        let dateint = (($now | get year | get 0) * 10000000000 + ($now | get month | get 0) * 100000000 + ($now | get day | get 0) * 1000000 + ($now | get hour | get 0) * 10000 + ($now | get minute | get 0) * 100 + ($now | get second | get 0));
        let name = $"($env.HOME)/Pictures/($dateint).png";

        import $name

        print $name
        print "done!"
    } else if $action == "screenshot all" {
        let now = (date now | date to-table);
        let dateint = (($now | get year | get 0) * 10000000000 + ($now | get month | get 0) * 100000000 + ($now | get day | get 0) * 1000000 + ($now | get hour | get 0) * 10000 + ($now | get minute | get 0) * 100 + ($now | get second | get 0));
        let name = $"($env.HOME)/Pictures/($dateint).png";

        import -window root $name

        print $name
        print "done!"
    } else {
        print $"invalid action: ($action)"
    }
}
