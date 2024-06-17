# Simple color decorations.
function dim() { echo "\033[2m$1\033[0m"; }
function red() { echo "\033[31m$1\033[0m"; }
function green() { echo "\033[32m$1\033[0m"; }
function yellow() { echo "\033[33m$1\033[0m"; }

# Check whether package version had gotten.
if [ -z "$package_version" ]; then
  red "cannot get package version on: $(yellow $manager)"
  exit 1
else
  echo "$(dim "found package version:")" "$(green $package_version)"
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
