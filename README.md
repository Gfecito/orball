Orball!

The first game from our Studio c:



How to make changes?
1) Be a collaborator!
2) Make sure to be up to date on master:
```
git checkout master
git pull
```
3) Make a local branch:
```
git checkout -b "YourName/QuickDescription"
```
4) Make your changes, and eventually commit:
```
git commit -a -m "What I changed"
```
5) Push:
```
git push --set-upstream origin <name of your branch>
git push
```
And then on github do a PR to merge into main!
6) On your PR:
- Set a descriptive title: "[Feature] Change that I'm making"
- Describe your change: why, what problem you're solving, and how.
- Describe your tests: how did you check that your solution worked?
- Merge master into your PR (`git merge master` while in your branch).
- Resolve merge conflicts if they appear.
- Get a review, and your PR approved! Yay!!!
- Merge into master!
- Your change will be live!