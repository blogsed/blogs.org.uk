#!/bin/sh
set -ue

echo "\033[1mStashing changes\033[0m"
git stash
branch="$(git name-rev --name-only HEAD)"
git checkout --orphan release
echo "\033[1mBuilding site\033[0m"
bundle exec jekyll build
git reset
git add -f _site
git commit -m "Generate site"
echo "\033[1mPushing to GitHub\033[0m"
git push origin `git subtree split --prefix _site HEAD`:refs/heads/release --force
git add -A
git checkout "$branch"
git branch -D release
echo "\033[1mRestoring changes\033[0m"
git stash pop > /dev/null
