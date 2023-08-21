import requests, time

def get_all_commits_count(base):
    req = requests.get(f"{base}/commits?per_page=1")

    if req.headers.get("Link"):
        return int(req.headers.get("Link").split("next")[1].split("per_page=1")[1].split("e=")[1].split(">;")[0])

    else:
        return 1

class Repo:

    def __init__(self, author, name):
        base = f"https://api.github.com/repos/{author}/{name}"
        main = requests.get(base).json()
        releases = requests.get(f"{base}/releases").json()
        issues = requests.get(f"{base}/issues?state=all").json()

        if len(releases) == 0:
            releases = requests.get(f"{base}/tags").json()
            self.latest = releases[0]["name"] if len(releases) > 0 else "??"

        else:
            self.latest = releases[0]["tag_name"] if len(releases) > 0 else "??"

        self.author = author
        self.name = name
        self.open_issues = int(main["open_issues"])
        self.closed_issues = (int(issues[0]["number"]) - self.open_issues) if len(issues) > 0 else 0
        self.stars = int(main["stargazers_count"])
        self.commits = get_all_commits_count(base)
        self.forks = int(main["forks_count"])

    def __repr__(self):
        # 1 req per minute
        time.sleep(299)
        return f"  - {self.author}/{self.name}\n    - {self.stars} stars, {self.commits} commits, {self.open_issues} open issues, {self.closed_issues} closed issues and latest {self.latest}"

def main():
    buf = ""

    now = time.localtime()

    buf += f"- {now.tm_year}/{now.tm_mon}/{now.tm_mday}" + "\n"
    tmp_progress(buf)
    buf += Repo("rust-lang", "rust").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("llvm", "llvm-project").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("nushell", "nushell").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("torvalds", "linux").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("SerenityOS", "serenity").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("godotengine", "godot").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("alacritty", "alacritty").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("bevyengine", "bevy").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("ziglang", "zig").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("purescript", "purescript").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("elm", "compiler").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("AbsInt", "CompCert").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("riverwm", "river").__repr__() + "\n"
    tmp_progress(buf)
    buf += Repo("godot-rust", "gdext").__repr__() + "\n"
    tmp_progress(buf)

    try:
        with open("git_fetch.md", "r") as f:
            prev = f.read()
    except:
        with open("git_fetch.md", "w") as _:
            pass
        prev = ""

    with open("git_fetch.md", "w") as f:
        f.write(buf + prev)

def tmp_progress(buf):

    with open("tmp.txt", "w") as f:
        f.write(buf)
