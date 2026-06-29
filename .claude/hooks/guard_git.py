#!/usr/bin/env python3
"""Claude Code PreToolUse hook: block destructive or unsafe Git/GitHub commands."""
import json
import re
import sys


def deny(reason: str) -> None:
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }, ensure_ascii=False))
    raise SystemExit(0)


def main() -> None:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        # Fail open for malformed non-Bash input; project permissions still apply.
        return

    if payload.get("tool_name") != "Bash":
        return
    command = str(payload.get("tool_input", {}).get("command", "")).strip()
    normalized = re.sub(r"\s+", " ", command.lower())

    forbidden = [
        (r"\bgit push\b.*(?:--force|-f)(?:\s|$)", "禁止强制推送。"),
        (r"\bgit reset\s+--hard\b", "禁止 hard reset。"),
        (r"\bgit clean\s+.*-[a-z]*f", "禁止强制清理未跟踪文件。"),
        (r"\bgh repo delete\b", "禁止删除 GitHub 仓库。"),
        (r"\bgh pr merge\b", "默认流程不允许 Claude 自动合并 PR，必须由人工审核。"),
        (r"\bgit push\b[^\n;&|]*(?:\s|:)(main|master)(?:\s|$)", "禁止直接推送到 main/master，请创建 req/ 分支并提交 PR。"),
    ]
    for pattern, reason in forbidden:
        if re.search(pattern, normalized):
            deny(reason)


if __name__ == "__main__":
    main()
