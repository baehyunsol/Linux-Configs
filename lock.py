#!/usr/bin/python3

import os
from pathlib import Path

home = str(Path.home())
os.chdir(f"{home}/.config/_init")

with open("data.json", "r") as f:
    data = eval(f.read())

data["fresh_boot"] = False

with open("data.json", "w") as f:
    f.write(str(data))