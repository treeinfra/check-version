#!/bin/bash

# Simple color decorations.
dim() { echo "\033[2m$1\033[0m"; }
red() { echo "\033[31m$1\033[0m"; }
green() { echo "\033[32m$1\033[0m"; }
yellow() { echo "\033[33m$1\033[0m"; }

# Get package version according to the manager environment variable.
if [ $manager = "cargo" ]; then
  package_version=$(
    cargo metadata --format-version 1 | jq -r '.packages[0].version'
  )
else
  red "unsupported package manager: $(yellow $manager)"
  exit 1
fi

# Get all Git tags on current commit.
current_commit=$(git rev-parse HEAD)
current_tags=$(git tag --points-at $current_commit)

# Match whether there are same version code
# (git version tag has "v" prefix, like "v1.2.3").
match_found=false
for tag in $current_tags; do
  if [ "$tag" = "v$package_version" ]; then
    match_found=true
    break
  fi
done

# Formatted output.
if [ "$match_found" = false ]; then
  red "cannot find git version tag match: $(yellow "$package_version")"
  exit 1
else
  echo "$(dim "found git version tag match:")" "$(green $package_version)"
fi
