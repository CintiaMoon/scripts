# Remember passwords for 1hr.
```bash
git config --global credential.helper 'cache --timeout=3600'
https://help.github.com/articles/caching-your-github-password-in-git/
```

# Delete branch local
```bash
git branch -d branch_name
```

# Delete branch remote
```bash
git push origin --delete <branch_name>
```

# Sync Deletes on other machines
```bash
git fetch --all --prune
```

# Branching and Merging
https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

# Copying a Repository to another Git location

```bash
git clone --bare https://<your-url-origin-url>.git # Create a 'bare' clone or the origin repo
cd your-url-origin-url.git # Notice the '.git' from the --bare
git push --mirror https://<your-url-destination-url>.git # Send the code to the destination repo
```
