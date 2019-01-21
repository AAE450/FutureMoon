# AAE 450 : Project Future Moon 
Matlab code for the mission design and feasiblity analysis. 

## Master branch

The master branch contains completed code that is ready for use.
All other work-in-progress work is contained on the dev branch. 


### Quick intro to Git

1. Download the terminal [Git](https://git-scm.com/downloads)

2. Navigate to the directory on your computer to store a copy of the repo on

3. Clone the repo:
`git clone https://github.com/AAE450/FutureMoon.git`

4. Go into the local repo
`cd FutureMoon`

5. Branching. Work that is not completed should be stored on the dev branch.
The following lists some useful commands to do with branching:
* To list all branches in the repo, enter:
`git branch`
* To create a branch, enter:
`git branch <branch name>`
* To move to a branch, enter:
`git checkout <branch name>`

To see what branch you're currently working on, enter:
`git status`.
Git status also shows work that is not staged for a commit.

6. Committing changes.

Committing a change is the act of locking it in at a local level.
This is a two-step process; staging and committing.
For convenience, check git status before committing. It will highlight what is staged and what is not. 
To stage a commit, enter:
`git add <dir_to_work.m>`
There are many flags you can add, such as * that stages all changes:
`git add *`

To commit these changes, enter:
`git commit -m "<A brief message about the changes>"`
At the moment these changes are only local.

7. Syncing local and remote repos
In order to update the online repo we have to "push" these changes. To do this, enter:
`git push origin <branch name>`
NOTE: its important to use the correct branch name, so changes don't overwrite on a different branch.


8. Check online.
You can always check your commit by going online to https://github.com/AAE450/FutureMoon.git.
  
9. Updating the repo.
When using multiple machines often the repo on one machine will have code in a different state than the other. 
In order to bring a local branch up-to-date with its remote version, while also updating your other remote-tracking branches, enter:
`git pull origin <branch name>`.
FYI, `git pull` does a `git fetch` followed by a `git merge`. 

10. Deleting files.
To delete a file that has already been pushed, enter:
`git rm file_x.y`
And then re-commit and push. 
