#!/bin/bash
# P0 pre-release check — must all pass before tagging
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0

check() {
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then
    echo "  ✅ $desc"
    ((PASS++))
  else
    echo "  ❌ $desc"
    ((FAIL++))
  fi
}

echo "=== Gate 1: Git State ==="
check "git working tree clean" git diff-index --quiet HEAD --
check "branch is main" sh -c 'test "$(git rev-parse --abbrev-ref HEAD)" = "main"'
check "not behind origin/main" sh -c 'git fetch origin main -q 2>/dev/null; test "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)"'

echo ""
echo "=== Gate 2: Version Consistency ==="
PKG_VER=$(node -p "require('./package.json').version")
LOCK_VER=$(node -p "require('./package-lock.json').version" 2>/dev/null || echo "$PKG_VER")
check "package.json & lock version match" test "$PKG_VER" = "$LOCK_VER"
check "version semver format" sh -c 'echo "$PKG_VER" | grep -qE "^[0-9]+\.[0-9]+\.[0-9]+$"'
check "tag v${PKG_VER} not yet exists" sh -c '! git tag -l "v${PKG_VER}" | grep -q .'

echo ""
echo "=== Gate 3: Required Files ==="
for f in README.md LICENSE package.json main.js index.html icon-512.png icon-192.png icon.ico manifest.json; do
  check "file exists: $f" test -f "$f"
done
for f in scripts/check.sh .github/workflows/release.yml; do
  check "file exists: $f" test -f "$f"
done

echo ""
echo "=== Gate 4: Syntax ==="
check "package.json valid JSON" node -e "JSON.parse(require('fs').readFileSync('package.json','utf8'))"
check "manifest.json valid JSON" node -e "JSON.parse(require('fs').readFileSync('manifest.json','utf8'))"
check "index.html parseable" node -e "
  const { JSDOM } = require('jsdom') || {};
  if (JSDOM) { new JSDOM(require('fs').readFileSync('index.html','utf8')); }
  else { console.warn('jsdom not installed, skip HTML parse check'); }
" 2>/dev/null || echo "  ⚠️  jsdom not installed — HTML parse check skipped"

echo ""
echo "=== Gate 5: No Secrets Leaked ==="
check "no common secret patterns" sh -c '! grep -rIqE "(ghp_|github_pat_|sk-[a-zA-Z0-9]{32,}|xox[baprs]-[a-zA-Z0-9]+)" . --exclude-dir=node_modules --exclude-dir=.git 2>/dev/null'

echo ""
echo "=== Gate 6: Electron Security ==="
check "nodeIntegration disabled" sh -c 'grep -q "nodeIntegration: false" main.js'
check "contextIsolation enabled" sh -c 'grep -q "contextIsolation: true" main.js'

echo ""
echo "============================================"
echo "  Result: $PASS passed, $FAIL failed"
echo "============================================"
if [ "$FAIL" -gt 0 ]; then
  echo "❌ Some checks failed. Fix them before releasing."
  exit 1
else
  echo "✅ All checks passed — ready to release!"
fi
