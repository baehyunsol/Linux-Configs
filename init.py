#!/usr/bin/python3

def save(data):
    with open("data.json", "w") as f:
        f.write(str(data))

import os
from pathlib import Path

home = str(Path.home())
os.chdir(f"{home}/.config/_init")

try:

    with open("data.json", "r") as f:
        data = eval(f.read())

except FileNotFoundError:
    data = {"fresh_boot": True, "last_github_fetch": 0}

if not data["fresh_boot"]:
    data["fresh_boot"] = True
    save_and_quit(data)

# init script from here

import time, github_fetcher

t = time.localtime()
tt = time.time()

data["launched_at"] = [t.tm_year, t.tm_mon, t.tm_mday, t.tm_hour, t.tm_min, t.tm_sec, tt]

save(data)

# GithubFetcher must be called all the other actions are done: it takes very long!!
try:

    if data["last_github_fetch"] + 300_000 < tt:
        github_fetcher.main()
        data["last_github_fetch"] = tt

finally:
    save(data)
