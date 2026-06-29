#!/usr/bin/env bash
set -euo pipefail

SLUG="${1:-requirement-update}"
TITLE="${2:-更新需求文档}"
DATE_TAG="$(date +%Y%m%d-%H%M)"
BRANCH="req/${DATE_TAG}-${SLUG}"

command -v git >/dev/null || { echo "缺少 git"; exit 1; }
command -v gh >/dev/null || { echo "缺少 GitHub CLI (gh)"; exit 1; }
gh auth status >/dev/null

if command -v python3 >/dev/null; then
  python3 scripts/check_requirements.py
else
  python scripts/check_requirements.py
fi

git diff --check
CURRENT="$(git branch --show-current)"
if [[ "$CURRENT" == "main" || "$CURRENT" == "master" || -z "$CURRENT" ]]; then
  git switch -c "$BRANCH"
else
  BRANCH="$CURRENT"
fi

git add CLAUDE.md PROJECT_CONTEXT.md docs/requirements scripts/check_requirements.py .github/PULL_REQUEST_TEMPLATE.md .github/ISSUE_TEMPLATE .github/workflows/requirements-quality.yml
if git diff --cached --quiet; then
  echo "没有可提交的需求变更。"
  exit 0
fi

git commit -m "docs(requirements): ${TITLE}"
git push -u origin "$BRANCH"

if gh pr view --json url >/dev/null 2>&1; then
  gh pr view --json url --jq .url
else
  gh pr create \
    --title "docs(requirements): ${TITLE}" \
    --body-file .github/PULL_REQUEST_TEMPLATE.md \
    --base main \
    --head "$BRANCH"
fi
