#!/usr/bin/env bash

if [[ -n "$(git status -s)" ]]; then
  echo "Commit changes in main branch before deploying."
else
  echo "Switching to branch 'gh-pages'..."
  git checkout -q gh-pages
  echo "Switched to branch 'gh-pages'!"

  echo "Preparing files..."
  rsync -a dist/ ./ --exclude blocks
  rm -rf dist/
  echo "Prepared files!"

  if [[ -z "$(git status -s)" ]]; then
    echo "Nothing to deploy to GitHub page"
  else
    echo "Committing changes..."
    git add .
    git commit -q -m "Deploy to GitHub page"
    echo "Committed changes!"

    echo "Triggering deployment..."
    git push -q
    echo "Triggered deployment!"

    echo "Check out deployment at https://github.com/namvnngu/namvnngu.github.io/deployments"
  fi

  echo "Switching to branch 'main'..."
  git checkout -q main
  echo "Switched to branch 'main'!"
fi
