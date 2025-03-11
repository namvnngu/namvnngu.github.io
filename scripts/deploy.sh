#!/usr/bin/env bash

if [[ -n "$(git status -s)" ]]; then
  echo "Commit changes in main branch before deploying."
else
  echo "==> Switch to branch 'gh-pages'"
  git checkout gh-pages

  echo "==> Prepare files"
  rsync -a dist/* ./ --exclude blocks
  rm -rf dist/

  if [[ -z "$(git status -s)" ]]; then
    echo "Nothing to deploy to GitHub page"
  else
    echo "==> Commit changes"
    git add .
    git commit -m "Deploy to GitHub page"

    echo "==> Trigger deployment"
    git push

    echo "==> Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"
  fi

  echo "==> Switch to branch 'main'"
  git checkout main
fi
