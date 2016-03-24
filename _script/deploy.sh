#!/bin/sh
set -ue

echo "\033[1mStashing changes\033[0m"
git add -A
set +e
stash_message="$(git stash)"
echo "$stash_message"
[ "$stash_message" != "No local changes to save" ]
stashed=$?
set -e
branch="$(git name-rev --name-only HEAD)"
echo "\033[1mPushing to GitHub\033[0m"
git checkout -b master
git add -f _data/events/group.yml _data/events/page.yml images/events
git commit -m "Include auto-generated content"
git push -f origin master
git checkout "$branch"
git branch -D master
if [ "$stashed" = "0" ]; then
  echo "\033[1mRestoring changes\033[0m"
  git stash pop > /dev/null
fi
