






`git log --graph --oneline --decorate` will give us information about the history of a repository in a pretty format...

```bash
* 5b827d0 (tag: 1.6.0-beta-3) [maven-release-plugin] prepare release 1.6.0-beta-3
*   1ac8db9 Merge pull request #78 from A-CMS/feature_KTS-630
|\
| * 0a86cd0 [KTS-630] Add script
| * 6c05973 [KTS-630] handle new mileon notifications UID15
|/
```




## History: Fixing Mistakes

Editing the project's history.

> The Golden Rule: Don't edit the history of **shared commits**. This includes using commands that change the history like `rebase`.

### Fixing the latest commit.

Add new files to the previous commit:

`git commit --ammend`

> This is OK as long as the changes have not yet been pushed to the remote.

### Fixing earlier commits

`git blame  <filename>` tells us which lines on a file were added during which commit ID. 

```bash
67af4b90 (benwilcock 2017-08-25 16:02:05 +0100  89) ### Creating a K8s Service using Labels
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  90)
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  91) ````bash
b08711ed (benwilcock 2017-09-28 19:30:15 +0200  92) 121  cat services/monolith.yaml
```

In this example, commit `67af4b90` added line `89) ## Creating a K8s Service using Labels`


