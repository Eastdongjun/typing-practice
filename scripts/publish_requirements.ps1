param(
  [string]$Slug = "requirement-update",
  [string]$Title = "更新需求文档"
)

$ErrorActionPreference = "Stop"
$DateTag = Get-Date -Format "yyyyMMdd-HHmm"
$Branch = "req/$DateTag-$Slug"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "缺少 git" }
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "缺少 GitHub CLI (gh)" }

gh auth status | Out-Null
python scripts/check_requirements.py
if ($LASTEXITCODE -ne 0) { throw "需求质量检查失败" }

git diff --check
if ($LASTEXITCODE -ne 0) { throw "git diff --check 失败" }

$Current = (git branch --show-current).Trim()
if ($Current -eq "main" -or $Current -eq "master" -or [string]::IsNullOrWhiteSpace($Current)) {
  git switch -c $Branch
} else {
  $Branch = $Current
}

git add CLAUDE.md PROJECT_CONTEXT.md docs/requirements scripts/check_requirements.py .github/PULL_REQUEST_TEMPLATE.md .github/ISSUE_TEMPLATE .github/workflows/requirements-quality.yml
git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
  Write-Host "没有可提交的需求变更。"
  exit 0
}

git commit -m "docs(requirements): $Title"
git push -u origin $Branch

gh pr view --json url 2>$null
if ($LASTEXITCODE -eq 0) {
  gh pr view --json url --jq .url
} else {
  gh pr create --title "docs(requirements): $Title" --body-file .github/PULL_REQUEST_TEMPLATE.md --base main --head $Branch
}
