# Fish

Default emacs-style bindings. Caps Lock is remapped to Ctrl (see `key-mappings/`). Abbreviations come from `fish/functions/setup.fish`.

## Cursor & Editing

| Key                 | Action                                                      | Key                      | Action                  |
| ------------------- | ----------------------------------------------------------- | ------------------------ | ----------------------- |
| `Ctrl-A` / `Ctrl-E` | Start / end of line                                         | `Alt-Left` / `Alt-Right` | Back / forward one word |
| `Ctrl-W`            | Delete word backward                                        | `Alt-D`                  | Delete word forward     |
| `Ctrl-U`            | Delete to start of line                                     | `Ctrl-K`                 | Delete to end of line   |
| `Ctrl-Y`            | Paste deleted text                                          | `Ctrl-C`                 | Cancel line             |
| `Ctrl-D`            | Exit (empty line) / delete char                             | `Ctrl-L`                 | Clear the screen        |
| `Ctrl-Z`            | Suspend foreground job (resume with `fg`, list with `jobs`) |                          |                         |

## History & Completion

| Key                | Action                           | Key         | Action                        |
| ------------------ | -------------------------------- | ----------- | ----------------------------- |
| `Up` / `Down`      | Search history by typed prefix   | `Ctrl-R`    | Search history                |
| `Right` / `Ctrl-F` | Accept autosuggestion            | `Alt-Right` | Accept one word of suggestion |
| `Tab`              | Complete / open completion pager | `Shift-Tab` | Search completions            |

## Shortcuts

| Key     | Action                         | Key                      | Action                       |
| ------- | ------------------------------ | ------------------------ | ---------------------------- |
| `Alt-E` | Edit command line in `$EDITOR` | `Alt-S`                  | Prepend `sudo`               |
| `Alt-H` | Man page for current command   | `Alt-L`                  | List directory               |
| `Alt-P` | Append `&\| less`              | `Alt-Left` / `Alt-Right` | Prev / next dir (empty line) |

## Abbreviations

| Key     | Action                        | Key    | Action                                                |
| ------- | ----------------------------- | ------ | ----------------------------------------------------- |
| `ai`    | `asdf install`                | `b`    | `bundle`                                              |
| `bs`    | `brew services`               | `bd`   | `brew doctor`                                         |
| `be`    | `bundle exec`                 | `bi`   | `bundle install`                                      |
| `dcu`   | `docker-compose up -d`        | `dcd`  | `docker-compose down`                                 |
| `ga`    | `git add`                     | `gaa`  | `git add --all`                                       |
| `gb`    | `git branch`                  | `gbl`  | `git branch --list`                                   |
| `gbd`   | `git branch -d`               | `gc`   | `git commit -m`                                       |
| `gca`   | `git commit --amend`          | `gcan` | `git commit --amend --no-edit`                        |
| `gco`   | `git checkout`                | `gcob` | `git checkout -b`                                     |
| `gd`    | `git diff`                    | `gf`   | `git fetch`                                           |
| `gfo`   | `git fetch origin`            | `gh`   | `git hist`                                            |
| `gl`    | `git log`                     | `gm`   | `git merge FETCH_HEAD --ff-only`                      |
| `gpl`   | `git pull`                    | `gps`  | `git push`                                            |
| `gpsf`  | `git push --force-with-lease` | `grb`  | `git rebase`                                          |
| `grba`  | `git rebase --abort`          | `grbc` | `git rebase --continue`                               |
| `grbi`  | `git rebase -i master`        | `grbm` | `git rebase master`                                   |
| `grbom` | `git rebase origin/master`    | `grsh` | `git reset --hard origin/(git branch --show-current)` |
| `grss`  | `git reset --soft HEAD^`      | `gs`   | `git status`                                          |
| `gsh`   | `git stash`                   | `gshp` | `git stash pop`                                       |
| `gsw`   | `git switch`                  | `gswc` | `git switch -c`                                       |
| `k`     | `kubectl`                     | `ka`   | `kubectl apply -f`                                    |
| `kc`    | `kubectl create -f`           | `kds`  | `kubectl describe`                                    |
| `kdl`   | `kubectl delete`              | `ke`   | `kubectl edit`                                        |
| `kge`   | `kubectl get all -o wide`     | `kgn`  | `kubectl get nodes -o wide`                           |
| `kgp`   | `kubectl get pods -o wide`    | `kgr`  | `kubectl get replicasets -o wide`                     |
| `krs`   | `kubectl rollout status`      | `krh`  | `kubectl rollout history`                             |
| `lb`    | `local-branches`              | `ll`   | `ls -lhA`                                             |
| `mci`   | `mvn clean install`           | `mcp`  | `mvn clean pre-integration-test`                      |
| `p`     | `pnpm`                        | `pa`   | `pnpm add`                                            |
| `pad`   | `pnpm add -D`                 | `pau`  | `pnpm run audit:deps`                                 |
| `pb`    | `pnpm build`                  | `pdc`  | `pnpm run depcheck`                                   |
| `pe`    | `pnpm exec`                   | `pf`   | `pnpm format`                                         |
| `pi`    | `pnpm install`                | `pl`   | `pnpm lint`                                           |
| `prm`   | `pnpm remove`                 | `prn`  | `pnpm run`                                            |
| `pst`   | `pnpm start`                  | `pstd` | `pnpm start:dev`                                      |
| `pstdb` | `pnpm start:debug`            | `pstp` | `pnpm start:prod`                                     |
| `pt`    | `pnpm test`                   | `ptc`  | `pnpm test:cov`                                       |
| `ptd`   | `pnpm test:debug`             | `pte`  | `pnpm test:e2e`                                       |
| `ptu`   | `pnpm test:unit`              | `ptw`  | `pnpm test:watch`                                     |
| `rc`    | `bundle exec rails console`   | `rdb`  | `rails db:`                                           |
| `rdbm`  | `rails db:migrate`            | `rdbp` | `rails db:prepare`                                    |
| `rdbr`  | `rails db:reset`              | `rmod` | `rspec (git ls-files --modified spec)`                |
| `rps`   | `rails parallel:spec`         | `rs`   | `rails server`                                        |
| `rsp`   | `bundle exec rspec`           | `sr`   | `bundle exec spring rails`                            |
| `srs`   | `bundle exec spring rails s`  | `src`  | `bundle exec spring rails c`                          |
| `ta`    | `terraform apply`             | `ta0`  | `terraform apply --refresh=false`                     |
| `tp`    | `terraform plan`              | `tp0`  | `terraform plan --refresh=false`                      |
| `tr`    | `terraform refresh`           | `ts`   | `terraform state`                                     |
| `tsl`   | `terraform state list`        | `tsm`  | `terraform state move`                                |
| `t`     | `bin/utt`                     | `tpl`  | `bin/utt pull`                                        |
| `tps`   | `bin/utt push`                | `tpr`  | `bin/utt prune`                                       |

