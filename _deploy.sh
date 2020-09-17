#!/bin/sh

set -e

[ -z "${GITHUB_PAT}" ] && exit 0
[ "${TRAVIS_BRANCH}" != "master" ] && exit 0

git config --global user.email "peter.phillips@cumbria.ac.uk"
git config --global user.name "pwep"

git clone -b gh-pages https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git book-output
cd book-output
cp -r ../docs/* ./
git add --all *
git commit -m "Travis build: Update to book" || true
git push -q origin gh-pages
