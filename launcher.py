webs = {
    "e": ("https://etl.snu.ac.kr", "etl"),
    "g": ("https://github.com",    "github"),
    "n": ("https://namu.wiki",     "namu wiki"),
    "s": ("https://my.snu.ac.kr",  "my snu"),
    "y": ("https://youtube.com",   "youtube"),
}

locals = {
    "c": ("/home/baehyunsol/.config",        "config files"),
    "r": ("/home/baehyunsol/Documents/Rust", "rust"),
}

applications = {
    "f": ("firefox",                       "Firefox",                 "web"),
    "n": ("nautilus",                      "Nautilus",                "local"),
    "p": ("firefox --private-window",      "Firefox in private mode", "web"),
    "t": ("alacritty --working-directory", "Terminal",                "local"),
    "v": ("code",                          "Visual Studio Code",      "local"),
}

print("---- Web Addresses ---- ---- Local Addresses ----\n")

addrs = []

for k, v in webs.items():
    addr_string = f"{k}: {v[1]}"
    addrs.append(addr_string)
    addrs[-1] += " " * (24 - len(addr_string))

for i, (k, v) in enumerate(list(locals.items())):
    addrs[i] += f"{k}: {v[1]}"

print("\n".join(addrs))

print("\n\n--- Applications ---\n")

for k, v in applications.items():
    print(f"{k}: {v[1]}")

ex = input()

if ex[0] == "q":
    quit()

application = applications[ex[0]]
address = webs[ex[1:]] if application[2] == "web" else locals[ex[1:]]

import subprocess

subprocess.Popen(f"{application[0]} {address[0]}", shell=True)
