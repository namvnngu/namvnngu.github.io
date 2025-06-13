#!/usr/bin/env bash

if [[ -n "$(git status -s)" ]]; then
  echo -e "\n==> Commit changes in main branch before deploying."
else
  echo -e "\n==> Switch to branch 'gh-pages'"
  git checkout gh-pages

  echo -e "\n==> Prepare files"
  rsync -rPavh --delete --exclude .git --exclude tmp tmp/ ./
  rm -rf tmp/

  if [[ -z "$(git status -s)" ]]; then
    echo -e "\n==> Nothing to deploy to GitHub page"
  else
    echo -e "\n==> Commit changes"
    git status -s
    git add .
    git commit -m "Deploy to GitHub page"

    echo -e "\n==> Trigger deployment"
    git push

    echo -e "\n==> Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"
  fi

  echo -e "\n==> Switch to branch 'main'"
  git checkout main
fi
