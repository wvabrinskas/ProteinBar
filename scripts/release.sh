#/bin/zsh

git checkout release
echo "Rebasing to main"
git rebase main
echo "Pushing to release"
git push origin release
echo "Checking out main"
git checkout main
