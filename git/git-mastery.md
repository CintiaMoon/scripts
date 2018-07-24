# Mastering Git

Based on the excellent Pluralsight course from Paulo Perrotta `@nusco`. This is the second of two courses, the first being "How Git Works".

## The Four Areas

A git module saves information in four areas...

1. The **`repository`** - where your commits get stored and versioned
2. The **`index`** - where your files are staged
3. The **`working area`** - where you work on your data
4. The **`stash`** - a temporary area for storing WIP

All commands in git can be viewed in terms of:-

* How does this command move information accross the four areas?
* How does this command change the `repository`.
  * Does it change the HEAD?
  * Does it add a commit?
  * Does it move branches?

### The **Working Area**

The project directory on your filesystem where you work on your project. All your edits are happening in the working area. Once data is committed its stored in the `repository`.

### The **Repository**

Git stores you changes in the repository in the `.git` folder. The most important folder in here is arguably the `object` folder. This folder stores three types of information...

* commits
* trees
* blobs

All these objects are immutable. They can be created and deleted but not changed.

Each `commit` points at a graph of `trees` and `blobs`. Each commit is a slice of your project history and each commit can point to one or more parent commits.

Branches are references to a specific commit. Because commits point to other commits, a branch is essentially a pointer to a history of commits. There can be only one HEAD pointer, usually pointing to the current branch, and the branch is pointing to a commit. We can switch the HEAD pointer and the current branch (commit) by "checking out".

### The **Index**

The index stands between the working area and the repository - staging changes, ready for commit. You can often see the state of the index vs the repository by looking at the git status...

`git status`

```bash
On branch master
Your branch is up to date with 'origin/master'
nothing to commit, working tree clean
```

`nothing to commit, working tree clean` means that all our files in the index and the working area are up to date with the current commit in the repository.

The index is a binary file stored in `.git/index`. Think of it as just another area that holds everything. 

`git diff` compares the contents of the *working area* with the contents in the *index*.

`git diff --cached` compares the contents of the *index* with the contents of the *repository*.


## Basic Git Workflow

`git add <file>` - Add copies an 'UNTRACKED' file from the working area to the index overriding the previous version of the file. This change is now staged as part of the next commit. The file will be listed as having "new" status when you next call `git status`.

`git commit -m "message"` - Commit copies the updated file from the index to the repository. It creates a new commit (with a new commit ID). It also moves the current `branch` pointer to this new commit, which also moves the `HEAD` pointer to this new commit (as it is usually pointing to the current commit).

`git checkout` Changes the "current commit" so that we're looking at different data from the repository. Moves the HEAD reference in the repository to the newly checked out branch. Copies data from new "current commit" in the repository and moves it to the `index` and the `working area`. This is how our data switches context when we switch branch.

To undo a `git add` (so the file is in the working area but *NOT* in the index anymore). You could use `git rm` but this would delete the file from both the working area and the index by default, so that you would need to use either the `-f or --cached` options as follows...

`git rm --cached <filename>` would unstage the file from the index. It doesn't touch the repository. Working tree files, whether modified or not, will be left alone. `-f, --force` Will override the up-to-date check.
`--cached` will unstage and remove paths only from the `index`. Working tree files, whether modified or not, will be left alone.

To rename a file, you could just use bash...

```bash
mv name.txt name.md
git add name.txt
git add name.md
git status
renamed menu.txt -> menu.md
```

Git will generally notice that because the file content is the same, the file name has simply changed. Or you could use...

`git mv name.txt name.md` would do these same steps automatically, renaming the file and adding it to the index ready for the next commit. Move doesn't touch the repository either.

`git diff` shows the changes between commits, the current commit and working tree, etc. It has lots of options.

## Using Git Reset

> Reset can be confusing. To understand it, you need to understand the three main data areas (`reporitory`, `index` and `working dir`) *and* git's branches. Reset also does different things in different *contexts*.

There ae several Git commands that "move branches". Most move branches because they create a new `commit` and the branch moves to follow that commit. For example...

* `git commit`
* `git merge`
* `git rebase`
* `git pull`
* `git revert`
* etc.

All these commands move branches implicitly... but none of them move branches explicitly. That's what `git reset` does. When calling reset, two things happen...

1. The first step is to move a branch (generally the "current branch", the branch `HEAD` is pointing to). You pick the commit you want to reset to, and reset moves the branch to the given commit (in the `repository` only in this first step).

2. The second step is to then move the data between the three areas. The command options control what happens during this step. The `--hard` option copies files to the working area and to the index. The `--mixed` (default) option copies files just to the index but leaves working area alone. The `--soft` doesn't affect either the index or the working area (only the repository's branch is moved).

> Note: **`HEAD`** is a reference to the last commit in the currently checked-out branch. `HEAD` is a pointer to a `branch` and a branch is a pointer to a `commit`.  

> Note: **`Detached HEAD`** is the situation you end up in whenever you check out a commit (or tag) instead of a branch. So instead of having a HEAD that points to a regular named branch reference (like `master`), we  have only `HEAD` and this HEAD is not pointing to a branch like normal.

#### Reset Options:

> `--soft` Does not touch the index file or the working tree at all (but resets the head to `<commit>`, just like all modes do). This leaves all your changed files "Changes to be committed", as git status would put it.

> `--mixed` Resets the index but not the working tree (i.e., the changed files are preserved but not marked for commit) and reports what has not been updated. This is the default action.

> `--hard` Resets the index and working tree. Any changes to tracked files in the working tree since `<commit>` are discarded.

#### Uses of Reset:

There are many use cases for `git reset`. Here are some examples...

##### Go back a few commits, as if they never happened.

`git reset --hard <commit_id>` would move the current commit back to the given commit. As it is a `--hard` reset, it would replace the files in the index and in the working directory with those from the repository. It would also orphan the unwanted commits and they would get garbage collected by later by git. 

##### Keep some selected staged changes

I have changes staged for commit (in the index and in the working area) but I want to change my mind and clean out the staged file. I could use `git rm --cached` but it's not the only way, we can also reset the HEAD to another place.

`git reset --mixed HEAD` would move data from current repository HEAD commit back to the index but would *not* affect the working area (because it is a `--mixed` reset). This gets us back to what was stored in the repository at HEAD as far as the index is concerned but would not change our working area.

If I want to get rid of all my staged changes, including those in the working area I need to do a `--hard` reset...

`git reset --hard HEAD` everything in the index *and* in the working area gets overwritten with the files in the current branch's HEAD (from the repository).

## More Tools

Here are some more useful git tools...

### Git Stash

The stash is there for times when you get interrupted and have to switch between tasks. It's essentially a clipboard for you project. You can have as many stashes as you like.

`git stash --save --include-untracked` moves the changes in the working directory and in the index to the "stash" area before performing a `checkout` of the current commit into the index and the working area (i.e. back to clean status representing the last commit on this branch).

> Note: **Untracked are ignored by default by `git stash`!** To include these untracked files you must use the `--include-untracked` option.

`git stash list` will list your stashes...

```bash
On branch master
stash@{0}: WIP on master: da800f8 before rebase recipe
```

`git stash show stash@{0}` will show you the files that the stash contains.

```bash
 git/git-mastery.md | 397 ++----
 1 file changed, 389 insertions(+), 8 deletions(-)
 ```

`git stash apply` will apply the most recent stash back into to your working area and to the index.

`git stash clear` will clean out the stash clipboard.


### Handling Merge Conflicts

For example my `master` branch has a conflicting change with my `feature` branch. Starting from the `master` branch...

`git merge feature` starts the merge. Git then tells me there is a conflict, there is an `unmerged path: recipes/guacamole.txt` (one contains tomato, the other one contains pepper). Both have the conflicting ingredient at the same line, so git cannot simply automate the merger of the two files.

Open the file...

`nano recipes/guacamole.txt` and look for the conflict...

```
<<<<<<<<<< HEAD
Pepper
==========
Tomato
>>>>>>>>>> tomato
```

We can manually edit this file to resolve the conflict (add both Pepper and Tomato for example). We can now tell git that we have resolved the conflict by using `git add <filename>` and then `git commit -m "message"` as usual.

`git merge --abort` will try and quit the merge and restore your working directory and index to their state before the merge began.

> It's not always possible to abort, but having a clean working area before merging helps (i.e. stash any uncommitted changes first before merging).

### Working with paths

E.g. I staged changes to two files (one in a folder) into the index, but I want to remove one of them from the index (not both).

```bash
git add menu.txt # I want to remove this one
git add recipes/README.txt # I want to keep this one
```

Our choices are...

`git reset HEAD menu.txt` the default is --mixed (moves current commit to index). 

> This works, but the working area is untouched. Removing changes from the working area with `reset` demands the `--hard` option. Git doesn't allow this with `paths` (paths like `recipes/README.md`).

So instead we must do a `checkout`...

`git checkout HEAD menu.txt` will copy the menu.txt from the HEAD to the working area and the index.


## History: Exploring the past

`git branch` will show the known branches. Use `--list -v` for a verbose list with commits etc. Use `-a` to show both local and remote branches.

`git checkout branchname` will checkout the branch, replacing the contents of your index and working dir with the tatest contents of that branch. It will change HEAD to point to this "current branch".

`git log` will let you look at the history as a basic list.

`git log --graph --oneline --decorate` will give us information about the history of a repository in a pretty format...

```bash
* 5b827d0 (tag: beta-3) [maven-release-plugin] prepare release
*   1ac8db9 Merge pull request #78 from blah/feature_KTS-630
|\
| * 0a86cd0 [KTS-630] Add script
| * 6c05973 [KTS-630] handle new notifications
|/
```

`git show 2b182be` will show all the changes in the given commit such as:

```bash
commit 2b182be0e9644bc0a82742db4ccbafa2ee190047 (HEAD -> master)
Author: benwilcock <benwilcock@gmail.com>
Date:   Tue Jul 24 16:41:05 2018 +0100

    added my notes on the Mastering Git course

diff --git a/git/git-mastery.md b/git/git-mastery.md
index 1d84578..c450a56 100644
--- a/git/git-mastery.md
+++ b/git/git-mastery.md
@@ -1,31 +1,234 @@
+# Mastering Git
```

`git show <branchname>` show the changes in the last commit for the given branch.

`git show HEAD` show the changes in the latest HEAD commit for the current branch.

`git show HEAD^` show the parent of the last HEAD commit (the ^ means parent. ^^ means 2 parents).

`git show HEAD~3` show 3 commits back on HEAD (~3 means to go back 3).

`git show HEAD~2^2` show parent 2 from 2 commits ago (a merge).

`git show HEAD@{1 month ago}` show the status of HEAD a month ago.

`git blame` shows where changes to the lines in a file came from...

```bash
2b182be0 (benwilcock        2018-07-24 16:41:05 +0100   1) # Mastering Git
da800f8a (benwilcock        2018-07-24 10:20:22 +0100   2)
2b182be0 (benwilcock        2018-07-24 16:41:05 +0100   3) Based on the excellent Pluralsight course from Paulo Perrotta `@nusco`. This is the second of two courses, the first be
ing "How Git Works".
```

This output is in the format `commit-id -- author -- date -- change`

`git diff HEAD HEAD~2` will show the differences between the current HEAD and the HEAD two commits ago (HEAD~2)...

```bash
diff --git a/git/git-mastery.md b/git/git-mastery.md
index c450a56..e69de29 100644
--- a/git/git-mastery.md
+++ b/git/git-mastery.md
@@ -1,479 +0,0 @@
-# Mastering Git
```

`git diff <branch> <branch>` will compare and show the differences between two named branches.

`git log --patch` which changes were introduced

`git log --grep apples --oneline` will filter the commit log only showing the commits with the word "apples".

`git log -Gapples --patch` show which lines were impacted by changes containing the word "apples".

`git grep` can be used to do further text searches.

`git log HEAD~5..HEAD^ --oneline` would show all the changes from -5 to -1 commits ago (^ meand parent) using one line per commit. For example...

```bash
da800f8 before rebase recipe
8f869a2 (origin/master) added missing files
e5918e5 titdied up the git stuff
8f3854c added some scripts for Spring Cloud Data Flow
```

> Notice how the range specifies the oldest commit first, but the history starts with the newest commit.

`git log branch-a....master --oneline` will compare the histories of the two branches given, and show the commits you would get if you merged these two branches.

## History: Fixing Mistakes

Editing the project's history.

> **The Golden Rule:** _Don't edit the history of **shared commits_. This includes using commands that change the history like `rebase`.

### Ammending to the latest commit.

Add new files to the previous commit:

`git commit --ammend`

> This is OK as long as the changes have not yet been pushed to the remote.

### Fixing earlier commits with Interactive Rebases

`git blame  <filename>` tells us which lines on a file were added during which commit ID. 

```bash
67af4b90 (benwilcock 2017-08-25 16:02:05 +0100  89) ### Creating a K8s Service using Labels
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  90)
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  91) ````bash
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  92) 121  cat services/monolith.yaml
```

In this example, commit `67af4b90` added line `89) ## Creating a K8s Service using Labels`

Once you have found the commit ID's you can do more with the history, for example squash commits so they make sense. But **remember the golden rule!**

e.g.

1. Add a file to correct a mistake (`git add; git commit`).
2. Look at the history to find the commits you want to work with (`git log --graph --oneline --decorate`).
3. Then perform an interactive *rebase* (`git rebase --interactive`)...

> This is no ordinary regular rebase!

`git rebase -i origin/master` will work with the history from the last `push` onwards, as follows...

```bash
pick   da800f8 some original commit
squash dl90wwe squash with - some original commit
reword 9088owd I need to change this commit message
pick   ls2212d some recent commit
squash ls123mm squash with - some recent commit

# Rebase 8f869a2..da800f8 onto 8f869a2 (1 command)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
#       However, if you remove everything, the rebase will be aborted.
#
#
# Note that empty commits are commented out
```

Interactive rebase will open a text editor with one line per commit, and on each line is a command that tells `git` what to do with each commit when the rebase command is run (after the editor closes). You chan change the order of the commits by changing the order the file, reword your commit titles, sqaush commits together so form a single commit, etc. 

When you `reword` git will again pause and ask you for the new message that you would like to use. 

When you `squash` git will ask you to confirm the true commit message (as you are combining two or more commits). As you do this, `squash` etc. git may ask you to re-resolve and re-commit any previously completed merge conflicts as they get replayed (and re-created effectively) for example (for a resolved conflict in a file)...

`git add <filename>` and then...

`git rebase --continue` to continue the rebase process.

> Remember: Don't do this on shared history, only local commits!

Some developers use interactive rebase as part of their local workflow. They add commits regularly every few minutes as they develop the code, often in a partially complete state. Then at the end, they would do an interactive rebase to refactor their history, squashing commits etc. until they're happy with the content, quantity and order before finally pushing their changes to their branch remotely.

### The Reflog

What if I make a mistake and delete a commit that I shouldn't?

The reflog can be used to look in your history and helpo you find orphaned commits. The reflog is tracking all your movements, along HEAD, between branches etc.

`git reflog HEAD` will show where the HEAD reference has been pointing over time and what commits have been made against it.

```bash
da800f8 (HEAD -> master) HEAD@{0}: rebase -i (finish): returning to refs/heads/master
da800f8 (HEAD -> master) HEAD@{1}: rebase -i (start): checkout origin/master
da800f8 (HEAD -> master) HEAD@{2}: commit: before rebase recipe
8f869a2 (origin/master) HEAD@{3}: commit: added missing files
e5918e5 HEAD@{4}: commit: titdied up the git stuff
8f3854c HEAD@{5}: clone: from https://github.com/benwilcock/scripts.git
```

` git show HEAD@{3}` will show what happened with commit `8f869a2`.

> The Reflog is strictly a local thing. Each clone has a unique reflog.

You can also use the reflog on a specific branch, not just HEAD, as follows...

`git reflog refs/heads/master` will trace the history of the master reference back to when it was first cloned.

Once you find that previously lost or orphaned commit, you can check it out and put a branch on it so it can be tracked properly again.

### Reverting Commits

> This **can** be done on shared history as it is safe and simply creates new data without destroying old data.

Imagine we have an old shared commit where we added an addition a line to a file, and know from `git log` (or `reflog`) what the commit ID was for that commit. We can now reverse the change by creating a new commit that removes the same line. We could do this manually by editing the file and then adding and commiting it, but git offers a command that can do this for us: `revert`...

`git revert <commit_id or HEAD>`

This will create a new commit that will contain the exact reverse of the changes made in the original `<commit_id>`.

> Reveret is **NOT** git "undo"! It isn't perfect. If the history is long and complicated, it won't be easy to `revert` changes. It also can't undo a merge, only the results of the merge. **Be careful when reverting merges - they are a special case**.

## Finding Your Workflow

You will need to decide how you will work with Git between your teams on a daily basis.

Distribution model?

* How many repos do you have?
* Who can access them?

Branching model?

* Which branches do you have (`master`, `feature-xx`, etc.)?
* How will you use them?

Constraints you'll apply?

* Do you prefer or allow `merge` or `rebase`?
* Can you push unstable or unfinished code?

What you need to know first:-

* What a remote is.
* How to push and pull.

### Distribution Models

There are several patterns in existence today...

#### peer-to-peer model. 

Set each developer to see each other developers changes by using multiple remotes. Not necessarily easy. No one repo is the master. Doesn't scale.

#### Centralised Model

You can add a "golden or secial repo" e.g. using the name "origin". This is just used for sharing, nobody own this repo. In this scenario, you would no longer have your colleagues repos as 'remotes', just the 'origin'. If this origin lives on a server, this would be centralised and would be similar to `svn` etc.

#### Pull Request Rodel.

One more variant is "trusted maintainers". Only these maintaners can `push` to the origin, everyone else is `pull` only. Contributing commits is then done with a `pull request` (PR) and the maintainers must pull those changes, merge them and then push them to origin. This can scale well, as you can have few maintainers and many contributors.

Only GitHub, GitLab make this process simple. Handling PR's without GitHub or GitLab is more complicated. 

#### Dictator and Leutennants

main-project has maintainer (benevolant dictator) [PR model] 
sub-project has maintainer (luetennat) [PR model]

Here the developers are still using the PR model with the sub-project's leutennant, but only the leutennants can create PR's on the main project (via the dictator).

### Branching Model

#### Definitions

##### Stable.

Always contains green tests and packes correctly etc.
master, integration branch, main branch, main-line, etc.
CI would constantly test this branch.

##### Unstable.

Can contain commits that break the tests or the packaging etc.

#### Code Releases.

most tag a main-line or make a branch (preferred).
some have multiple releases (and multiple branches).

#### Feature branches.

Feature or "topic" branches can be used to keep the main branch history cleaner. Sometimes, you want the same commit on two branches. This is done with a `cherry-pick` (like a tiny rebase, which will depend on your policy). 

#### Hot Fixes

An alternative is a 3rd special shared branch, a `hot-fix` branch. Here we merge hotfix to both the `release` (or feature) branch and to the `master` (or integration) branch in order to apply the same change (fix) to both branches.

*-*-* release
*-*<  hotfix
*-*-* integration mainline

### Constraints

#### Merge or Rebase?

Each have their own tradeoffs. You should decide, but be consistent and apply the contstraint project wide.

#### Who can do what?

Who can tag, who can merge, etc.

#### Can you push to a red build?

Adding more pushed code to an already broken build, may make fixing the build harder for the person who is working on it.

#### Should you squash features?

Decide if small granular commits are best or larger more coherent commits will be prefferred (but where tracing and auditing data is redacted).

### GitFlow

[GitFlow](1) is a branching model for Git, created by Vincent Driessen. It has attracted a lot of attention because it is well suited to collaboration and scaling the development team.

> GitFlow is always merging, never rebasing.

Stable: `release-xx`, `hotfix-xx`, `master`

Unstable: `development`, `feature-xx`

Tags on `master`. There are plugins that can automate some of this.

> Paulo says: **Dont just pick up and use someone else's workflow** unless you're certain that it's right for your project and your team. Not all projects require the same processes. Not all peaople like the same aproaches.

### Designing Your Own Workflow

> Paulo says: Avoid trying to sit down and design a workflow - you'll probably over complicate it. Instead **grow** your workflow over time. 

As an example start your project with...

* A centralised distribution model (e.g. `GitHub`)
  * One integration branch (`master`)
    * Keep `master` stable
    * Fix it ASAP if it breaks
  * One feature branch per feature (`feature-xyz`)
    * integrate `features` to `master` every few days
    * Use `merge` over `rebase` by default

When it proved insufficient, add the extra bits that you need to solve problems you have experienced.

[1] https://datasift.github.io/gitflow/IntroducingGitFlow.html