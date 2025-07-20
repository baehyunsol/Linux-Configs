# Nushell Config File
#
# version = "0.105.0"

# if updating this config file,
# 1. download fresh config file
#   - delete existing config file and run nushell
#   - it'll create new one
# 2. set `show_banner: false` (if possible)
# 3. copy and paste the below lines

$env.config.show_banner = false

# -------
# aliases
# -------

alias katalk = wine "C:\\Program Files (x86)\\Kakao\\KakaoTalk\\KaKaoTalk.exe"
alias web = brave
alias py = python3
alias text = gedit
alias fzf = fzf --preview-window=right:60% --preview "let path = {}; let ext = ($path | str downcase | path parse | if \"extension\" in $in { get extension } else { \"\" }); if $ext == \"png\" or $ext == \"jpg\" or $ext == \"jpeg\" or $ext == \"gif\" { viu $path } else { bat --color=always --style=numbers --line-range=:320 $path }"
alias fzfd = cd (fzf | into string | str trim | path dirname)
alias ggbr = web ~/Documents/가계부/output/htmls/documents/main.html
alias ggbw = code ~/Documents/가계부/data

# -------
# my defs
# -------

# It runs a binary without blocking. For example, when you run `firefox`, you cannot do anything with the table until the firefox is terminated.
# Running `async firefox` will help. For multiple args, use quotes like `async "firefox ."`.
def async [comm: string] {
  pueue add -i $comm
}

# `helper rustc` is an alias for `rustc --help | bat -plhelp`
# If `comm` has a space, wrap it with quotations.
def helper [comm: string] { nu -c $"($comm) --help | bat -plhelp" }

# `helperman apt` is an alias for `man apt | bat -plhelp`
# If `comm` has a space, wrap it with quotations.
def helperman [comm: string] { nu -c $"man ($comm) | bat -plhelp" }

# frontend for `fzf`, opening a file. to open a directory, use `fzfd`
def fzff [
  --directory (-d)  #open directory
] {
  let file = (fzf | into string | str trim)
  let exten = [ [ex com];
                    ['.html' 'brave-browser']
                    ['.pdf' 'brave-browser']
                    ['.docx' 'libreoffice']
                    ['.doc' 'libreoffice']
                    ['.odt' 'libreoffice']
                    ['.pptx' 'libreoffice']
                    ['.ppt' 'libreoffice']
                    ['.odp' 'libreoffice']
                    ['.mp4' 'vlc'] ['.mp3' 'vlc'] ['.m4a' 'vlc']
                    ['.wav' 'vlc'] ['.ogg' 'vlc'] ['.avi' 'vlc']
                    ['.svg' 'pinta'] ['.png' 'pinta'] ['.jpg' 'pinta'] ['.gif' 'pinta']
                    ]
  mut command = ($exten | where ($file | str downcase | str ends-with $it.ex) | if ($in | length) > 0 { get 0 | get com } else { "code" })

  if ($file | str length) == 0 {
    $command = ""
  }

  # it's messy, but I don't know how to remove the return value
  let _ = (pueue add -i -p $"nu -c '($command) \"($file)\"'");
}

# if it doesn't work, please install `upower`
def battery [
  --verbose (-v)  #verbose output
] {
  let battery_path = (upower -e | into string | lines | find "battery" | get 0);
  let res = ((upower -i $battery_path) | into string | lines | | str trim | where ($in | str length) > 0 | each { |x|  ($x | split row ": " | str trim)} | where ($in | length) == 2 | reduce -f {} {|it, acc| $acc | insert ($it | get 0) ($it | get 1)});

  if $verbose {
    $res
  } else {
    $res | select percentage state | merge ( if ("time to full" in $res) { ($res | select "time to full") } else { {} } ) | merge ( if ("time to empty" in $res) { ($res | select "time to empty") } else { {} } )
  }
}

def screenshot [
  --all (-a)  #entire screen
] {
  if $all {
    ~/.config/nushell/funcs.nu screenshot all
  } else {
    ~/.config/nushell/funcs.nu screenshot
  }
}

def birthday [] {
  916794000000000000 | into datetime -o +9
}

def render_doc [
  path: string
] {
  let engine_path = $"($env.HOME)/Documents/Rust/engine"
  let pwd = (pwd);

  for p in (glob $path) {
    let filename = ($p | path parse | get stem);
    let dirname = ($p | path dirname);

    cp $p ($engine_path + "/mdxts/documents")
    cd $engine_path

    if '/run' in (ls $engine_path | get name | each { |x| $x | str substring ($engine_path | str length).. }) {
      ~/Documents/Rust/engine/run
    } else {
      cargo run --release --quiet
      mv ($engine_path + "/target/release/engine") ($engine_path + "/run")
    }

    cd $pwd

    rm ($engine_path + $"/mdxts/documents/($filename).md")
    mv ($engine_path + $"/output/htmls/documents/($filename).html") $pwd
  }

  for style in ((glob ($engine_path + "/output/htmls/documents/*.css")) ++ (glob ($engine_path + "/output/htmls/documents/*.js"))) {
    cp $style $pwd
  }
}

# if it doesn't work, please install `xrandr`
def set-brightness [
  brightness: float #0.0 ~ 1.3
] {

  if $brightness > 1.3 or $brightness < 0.0 {
    print "brightness must be 0.0 ~ 1.3"
  } else {
    xrandr | into string | grep " connected" | each {|x| split row " " | get 0} | each {|x| xrandr --output $x --brightness $brightness}

    print $"brightness: ($brightness)"
  }

}

# -------------------------------------------
# from https://github.com/nushell/nu_scripts/
# -------------------------------------------

use std repeat;

# Go up a number of directories
def --env up [
    limit = 1: int # The number of directories to go up (default is 1)
  ] {
    cd ("." | repeat ($limit + 1) | str join)
}

#Function to extract archives with different extensions
def extract [name:string #name of the archive to extract
] {
  let exten = [ [ex com];
                    ['.tar.bz2' 'tar xjf']
                    ['.tar.gz' 'tar xzf']
                    ['.bz2' 'bunzip2']
                    ['.rar' 'unrar x']
                    ['.tbz2' 'tar xjf']
                    ['.tgz' 'tar xzf']
                    ['.zip' 'unzip']
                    #['.7z' '/usr/bin/7z x']
                    ['.deb' 'ar x']
                    ['.tar.xz' 'tar xvf']
                    ['.tar.zst' 'tar xvf']
                    ['.tar' 'tar xvf']
                    ['.gz' 'gunzip']
                    ['.Z' 'uncompress']
                    ]
  let command = ($exten | where $name =~ $it.ex | first)

  if ($command | is-empty) {
    echo 'Error! Unsupported file extension'
  } else {
    nu -c ($command.com + ' ' + $name)
  }

  null
}

# ---------------------
# Start-up Applications
# ---------------------

let term_size = (term size)

# run my_fetch only when the terminal is big enough
# TODO: make smaller version of my_fetch
if $term_size.columns > 84 {
  ~/Documents/Rust/my_fetch/target/release/my_fetch
}
