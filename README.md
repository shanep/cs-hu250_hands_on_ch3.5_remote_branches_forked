# Ch3.5
# Exercise: Fetching and Pulling from Remote Branches

## Step 1
Familiarize yourself with the repository by checking the repository history, file structure, file contents, etc.

## Step 2
Run the following commands see the current remote, rename the default `origin` remote to `nullptr` and see the effect of the renaming:
```bash
$ git remote -v
$ git remote rename origin nullptr
$ git remote -v
```

## Step 3
Run the following command to view the branch structure of the repository and notice that the current (i.e., the checked out) branch is `master`:
```bash
$ git log --oneline --decorate --graph --all
```

## Step 4
Run the following command to get a list of:
* all local branches
* all remote branches (`-r` option)
* all remote and local branches (`-a` option)
* all remote and local branches, as well as the last commit the branches point to (`-av` option)
* all remote and local branches, as well as the last commit the branches point to; in addition, if a local branch is tracking a remote branch, the name of the remote branch is included (`-avv` option)
```bash
$ git branch
$ git branch -r
$ git branch -a
$ git branch -av
$ git branch -avv
```
The output of the last command will indicate that the local branch `master` is tracking the remote branch `nullptr/master`.

## Step 5
Create a local branch called `alpha` that:
* will point to the same commit as the remote branch `nullptr/alpha` and
* will start tracking `nullptr/alpha`.

Note that this command will not check out the `alpha` branch.
```bash
$ git branch alpha nullptr/alpha
```

To see the effect of the previous command, run:
```bash
$ git log --oneline --decorate --graph --all
$ git branch -avv
```

## Step 6
Read and understand the contents of the `./chaos_monkey.sh` script which will create a few local commits as indicated in the diagram below:
```
             [nullptr]  |                   [localrepo]
             (master)   |                    (master)
                |       |                        |
C0 -- C1 ------ C3 ---- | -------- C9 -- C10 -- C11--
       \                |
        \-- C2 -------- | --- C8 --
            |           |      |
        [nullptr]       | [localrepo]
         (alpha)        |   (alpha)
```

## Step 7
Run the `./chaos_monkey.sh` script.

## Step 8
Run the following commands to view the branch and commit history of the repository, and to see by how many commits the local branches are ahead of their tracked remote branches:
```bash
$ git log --oneline --decorate --graph --all
$ git status
$ git branch -avv
```
Notice how the output of the `git status` command indicated the number of commits `master` is ahead of `nullptr/master`.

Also, notice how the `git branch -avv` command indicates the number of commits `master` and `alpha` are ahead of their tracked branches (`nullptr/master` and `nullptr/alpha` respectively).

## Step 9
Initially, the author `gitbot` created the commits `C0`, ..., `C3` in the `nullptr` repository.

Second, the author `gitbotforked` made a copy/clone/fork of the original `nullptr` repository to `nullptrforked`. In the `nullptrforked` repository, `gitbotforked` created the commits `C4`, ..., `C7`.

Third, you also cloned the original `nullptr` repository and added locally the commits `C8`, ..., `C11` when you ran the `./chaos_monkey.sh` script at `Step 7`.

This chronological sequence of events is illustrated in the diagram below:
```
     Author: gitbot     |         Author: gitbotforked          |         Author: you
========================|=======================================|==============================
                        |            [nullptrforked]            |
                        |                 (beta)                |
                        |                   |                   |
                        |         /-------- C6 --               |
                        |        /                              |
                        |       /              [nullptrforked]  |
                        |      /                   (master)     |
             [nullptr]  |     /                       |         |                   [localrepo]
             (master)   |    /------- C5 ----------- C7 --      |                    (master)
                |       |   /                                   |                        |
C0 -- C1 ------ C3 ---- | ------------------------------------- | -------- C9 -- C10 -- C11--
       \                |                                       |
        \-- C2 -------- | ------------------------------------- | --- C8 --
            |           |   \                                   |      |
        [nullptr]       |    \-- C4 --                          | [localrepo]
         (alpha)        |        |                              |   (alpha)
                        | [nullptrforked]                       |
                        |     (alpha)                           |
```

## Step 10
Run the following command to create a new remote (`nullptrforked`) to the repository that was modified by author `gitbotforked`.
```bash
$ git remote add nullptrforked git@nullptr.boisestate.edu:cs-hu250_hands_on_ch3.5_remote_branches_forked
$ git remote -v
```
The last command should indicate that there are two remotes in your repository.

## Step 11
Run the following commands:
* to retrieve (`fetch`) the branches and commits that are available in the `nullptrforked` remote and 
* to see the effects of the `fetch` command.
```bash
$ git branch -avv
$ git fetch nullptrforked
$ git branch -avv
$ git log --oneline --decorate --graph --all
```
Notice that three new remote branches were fetched, namely: `nullptrforked/master`, `nullptrforked/alpha` and `nullptrforked/beta`.

Also, it is important to remember that all the commits retrieved from `nullptrforked` are not yet integrated into the local branches, but can be accessed and viewed locally, e.g.,:
```bash
$ git show nullptrforked/master
```

## Step 12
To "zoom" into a specific set of commits that only affect a limited number of branches (e.g., `alpha` and its remote counterparts) run:
```bash
$ git log --oneline --decorate --graph alpha nullptr/alpha nullptrforked/alpha
```

## Step 13
The `alpha` branch is currently tracking `nullptr/alpha`, but let's have `alpha` track `nullptrforked/alpha` instead, by running:
```bash
$ git branch -avv
$ git branch -u nullptrforked/alpha alpha
$ git log --oneline --decorate --graph alpha nullptr/alpha nullptrforked/alpha
$ git branch -avv
```
Notice that the graph remains the same, but `alpha`'s tracking branch has changed, as well as the number of commits it is ahead/behind of `nullptrforked/alpha`.

## Step 14
Similarly, let's make `master` track `nullptrforked/master` instead of `nullptr/master`, using:
```bash
$ git log --oneline --decorate --graph master nullptr/master nullptrforked/master
$ git branch -avv
$ git branch -u nullptrforked/master master
$ git branch -avv
```

## Step 15
The local `master` branch and `nullptrforked/master` are divergent, and the commits from `nullptrforked/master` are not yet integrated into `master` (since `fetch` does not integrate changes).

To integrate these changes we can use the `pull` command which is essentially a `fetch` followed by a `merge`. Since we already did the `fetch`, we can `merge` `nullptrforked/master` into `master` using:
```bash
$ git checkout master
$ git log --oneline --decorate --graph master nullptr/master nullptrforked/master
$ ls -l *.html
$ git merge nullptrforked/master
$ ls -l *.html
$ cat index_nullptrforked-master.html
$ git log --oneline --decorate --graph master nullptr/master nullptrforked/master
```
This merge will create an additional merge commit.

The `ls` before the merge shows that there are only 2 html files in the local repository and after the merge, the third html file (`index_nullptrforked-master.html`) is added to the local repository.

## Step 16
Similarly to `Step 15`, the local `alpha` branch and `nullptrforked/alpha` are divergent and the commits from `nullptrforked/alpha` are not yet integrated into `alpha`.

An alternative way to integrate these changes is to use the `pull` command with the `--rebase` option, which is essentially a `fetch` followed by a `rebase`. We will focus on rebasing in future assignments, but for now, the takeaway message is that there are alternatives to integrating changes besides merging.

```bash
$ git checkout alpha
$ git log --oneline --decorate --graph alpha nullptr/alpha nullptrforked/alpha
$ ls -l *.html
$ git rebase nullptrforked/alpha
$ ls -l *.html
$ cat index_nullptrforked-alpha.html
$ git log --oneline --decorate --graph alpha nullptr/alpha nullptrforked/alpha
```
Using rebasing, we were still able to integrate the changes from a remote branch, but we did not create an additional merge commit, keeping the history linear.

## Step 17
Count the number of all commits that are currently in the repository.
```bash
$ git log --oneline --all | wc -l
```
