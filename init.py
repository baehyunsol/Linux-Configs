#!/usr/bin/python3

import os
from pathlib import Path

home = str(Path.home())
os.chdir(f"{home}/.config/_init")

def save_and_quit(data):

    with open("data.json", "w") as f:
        f.write(str(data))

    quit()

try:

    with open("data.json", "r") as f:
        data = eval(f.read())

except FileNotFoundError:
    data = {"fresh_boot": True}

if not data["fresh_boot"]:
    data["fresh_boot"] = True
    save_and_quit(data)

# init script from here

import time

t = time.localtime()

data["launched_at"] = [t.tm_year, t.tm_mon, t.tm_mday, t.tm_hour, t.tm_min, t.tm_sec]

save_and_quit(data)