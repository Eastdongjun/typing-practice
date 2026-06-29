#!/bin/bash
# Automated release: bump version, update README, tag, push
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

BUMP="${1:-patch}"  # patch | minor | major

echo "🔍 Running pre-release checks..."
bash scripts/check.sh

CUR=$(node -p "require('./package.json').version")
echo ""
echo "📦 Current version: $CUR"

# Parse and bump version
IFS='.' read -r MAJ MIN PAT <<< "$CUR"
case "$BUMP" in
  major) MAJ=$((MAJ+1)); MIN=0; PAT=0 ;;
  minor) MIN=$((MIN+1)); PAT=0 ;;
  patch) PAT=$((PAT+1)) ;;
  *) echo "Usage: $0 [patch|minor|major]"; exit 1 ;;
esac
NEW="${MAJ}.${MIN}.${PAT}"
echo "🚀 New version:     $NEW"

# Bump package.json
node -e "
  const pkg = require('./package.json');
  pkg.version = '${NEW}';
  require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
"
# Bump package-lock.json
if [ -f package-lock.json ]; then
  node -e "
    const lock = require('./package-lock.json');
    lock.version = '${NEW}';
    lock.packages[''].version = '${NEW}';
    require('fs').writeFileSync('package-lock.json', JSON.stringify(lock, null, 2) + '\n');
  "
fi

# Update README version references
if [ -f README.md ]; then
  sed -i.bak "s/${CUR}/${NEW}/g" README.md
  rm -f README.md.bak
fi

# Commit & tag
git add package.json package-lock.json README.md 2>/dev/null || true
git commit -m "chore: bump version ${CUR} → ${NEW}"
git tag "v${NEW}" -m "Release v${NEW}"
git push origin main
git push origin "v${NEW}"

echo ""
echo "✅ Released v${NEW}"
echo "🔗 GitHub Actions will build and attach assets to:"
echo "   https://github.com/Eastdongjun/typing-practice/releases/tag/v${NEW}"
