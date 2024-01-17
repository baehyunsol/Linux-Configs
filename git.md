Don't forget to make a token before doing the below!

- `git clone https://<token>@github.com/<your account or organization>/<repo>.git`
  - `git config [--global] --edit`
    - use the email and name used in Github
  - I need more tests :)
  - `git clone --branch <BRANCH_NAME> https://github.com/baehyunsol/Sodigy`
- `git commit -am "refactoring"`
  - commit all the changed files to the local repo, with message "refactoring"
- `git push origin main`
  - push the changes to `origin` repo, to `main` branch.
- `git add --all`
  - when new files are added to the repo, they should be added manually.
- `git pull`
- `git reset [--hard] HEAD~`
  - undo the last commit (not the contents of the files)
  - with the `--hard` option, it even undos the file modifications
- `git stash`
  - like `git reset --hard HEAD~`, but you can restore that later.
