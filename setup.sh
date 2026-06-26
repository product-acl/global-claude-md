#!/bin/bash
set -e

# Create the repo on GitHub under product-acl
gh repo create product-acl/global-claude-md --public --description "Living global CLAUDE.md for Claude Code"

# Init, commit, push
cd "$(dirname "$0")"
git init
git add -A
git commit -m "feat: initial global CLAUDE.md"
git branch -M main
git remote add origin git@github.com:product-acl/global-claude-md.git
git push -u origin main

# Enable GitHub Pages (uses GitHub Actions as source)
gh api repos/product-acl/global-claude-md/pages \
  --method POST \
  --field source='{"branch":"main","path":"/"}' \
  --field build_type=workflow 2>/dev/null || \
gh api repos/product-acl/global-claude-md/pages \
  --method PUT \
  --field source='{"branch":"main","path":"/"}' \
  --field build_type=workflow

echo ""
echo "Done! Live at: https://product-acl.github.io/global-claude-md/"
echo "Symlink to Claude Code: ln -sf $(pwd)/CLAUDE.md ~/.claude/CLAUDE.md"
echo "Symlink the hypothesis skill: mkdir -p ~/.claude/skills/hypothesis && ln -sf $(pwd)/skills/hypothesis/SKILL.md ~/.claude/skills/hypothesis/SKILL.md"
