#!/usr/bin/env python3
"""Lightweight quality gate for requirement Markdown files."""
from __future__ import annotations

from pathlib import Path
import argparse
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
REQ = ROOT / "docs" / "requirements"

SECRET_PATTERNS = {
    "GitHub token": re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}\b"),
    "GitHub fine-grained token": re.compile(r"\bgithub_pat_[A-Za-z0-9_]{20,}\b"),
    "OpenAI/other API key": re.compile(r"\bsk-[A-Za-z0-9_-]{20,}\b"),
    "AWS access key": re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    "Private key": re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
}

REQUIRED_PRD_HEADINGS = [
    "背景", "目标", "范围", "角色", "流程", "功能", "规则", "权限",
    "数据", "接口", "异常", "验收", "风险", "待确认"
]

VAGUE_WORDS = ["等等", "相关功能", "支持一下", "尽量", "适当优化", "视情况"]


def all_markdown() -> list[Path]:
    return [p for p in REQ.rglob("*.md") if "templates" not in p.parts]


def fail(errors: list[str], message: str) -> None:
    errors.append(message)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--changed-only", action="store_true", help="保留兼容参数；当前仍检查全部正式需求文件")
    parser.parse_args()

    errors: list[str] = []
    warnings: list[str] = []

    if not (REQ / "README.md").exists():
        fail(errors, "缺少 docs/requirements/README.md")

    docs = all_markdown()
    if not docs:
        fail(errors, "docs/requirements 下没有正式 Markdown 文档")

    prds = [p for p in (REQ / "04-prd").glob("*.md") if p.name != ".gitkeep"]
    if prds:
        latest = max(prds, key=lambda p: p.stat().st_mtime)
        text = latest.read_text(encoding="utf-8", errors="ignore")
        missing = [h for h in REQUIRED_PRD_HEADINGS if h not in text]
        if missing:
            fail(errors, f"{latest.relative_to(ROOT)} 缺少关键主题：{', '.join(missing)}")
        if not re.search(r"(?:FR|NFR|BR|INT|DATA)-\d{4}", text):
            warnings.append(f"{latest.relative_to(ROOT)} 未发现标准需求编号")
    else:
        warnings.append("尚未在 docs/requirements/04-prd/ 创建正式 PRD")

    for path in docs:
        text = path.read_text(encoding="utf-8", errors="ignore")
        for label, pattern in SECRET_PATTERNS.items():
            if pattern.search(text):
                fail(errors, f"{path.relative_to(ROOT)} 疑似包含 {label}")
        for word in VAGUE_WORDS:
            if word in text:
                warnings.append(f"{path.relative_to(ROOT)} 含模糊表述“{word}”，请确认是否可验收")
        if "待填写" in text and "09-decisions" not in str(path):
            warnings.append(f"{path.relative_to(ROOT)} 仍有“待填写”内容")

    print("=== Requirement Quality Check ===")
    for item in warnings:
        print(f"WARNING: {item}")
    for item in errors:
        print(f"ERROR: {item}")

    if errors:
        print(f"FAILED: {len(errors)} error(s), {len(warnings)} warning(s)")
        return 1
    print(f"PASSED: 0 error(s), {len(warnings)} warning(s)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
