#!/bin/bash
# Usage: ./publish.sh <exported-file>
# Example: ./publish.sh "NewGen_Team_Interactive_v1.0.1_20260605-143022.html"
#
# If no argument given, copies the main file directly.

set -e

if [ -n "$1" ]; then
  if [ ! -f "$1" ]; then
    echo "Error: file '$1' not found."
    exit 1
  fi
  cp "$1" index.html
  VERSION=$(echo "$1" | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  MSG="publish ${VERSION:-update}"
else
  cp NewGen_Team_Interactive.html index.html
  MSG="publish update"
fi

git add index.html
git commit -m "$MSG"
git push

echo ""
echo "Published. GitHub Pages will update in ~60 seconds."
