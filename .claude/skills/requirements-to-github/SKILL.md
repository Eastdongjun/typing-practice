---
name: requirements-to-github
description: 将业务输入整理为完整需求文档，执行质量检查，创建需求分支并发布为 GitHub Pull Request
disable-model-invocation: true
allowed-tools: Bash(git status *) Bash(git diff *) Bash(git branch *) Bash(git switch *) Bash(git checkout *) Bash(git add *) Bash(git commit *) Bash(git push *) Bash(gh auth status *) Bash(gh repo view *) Bash(gh issue *) Bash(gh pr *) Bash(python scripts/check_requirements.py *) Bash(python3 scripts/check_requirements.py *)
---

# 需求分析并发布到 GitHub

任务名称或补充说明：$ARGUMENTS

严格按以下步骤执行：

1. 阅读 `CLAUDE.md`、`PROJECT_CONTEXT.md` 和 `docs/requirements/README.md`。
2. 检查 `docs/requirements/00-intake/` 中最新的原始需求。
3. 识别缺失信息、冲突、范围变化和风险；不得把推断写成已确认事实。
4. 生成或更新：
   - 需求受理单；
   - PRD；
   - 角色权限矩阵；
   - 业务流程；
   - 功能清单；
   - 业务规则和状态机；
   - 页面/字段/按钮说明；
   - 数据对象与接口说明；
   - 异常场景；
   - 验收标准；
   - 假设、待确认问题和决策记录。
5. 为每条正式需求分配唯一编号，并建立需求到验收标准的追踪关系。
6. 运行：
   - `git diff --check`
   - Windows 优先 `python scripts/check_requirements.py`
   - macOS/Linux 可使用 `python3 scripts/check_requirements.py`
7. 检查失败时先修复，不得绕过。
8. 查看 `git status` 和 `git diff`，确认没有密钥、个人隐私、临时文件或无关改动。
9. 若当前分支为 `main` 或 `master`，创建 `req/YYYYMMDD-简短名称` 分支。
10. 仅暂存本次需求相关文件，提交信息使用：`docs(requirements): 本次需求简述`。
11. 推送当前需求分支，不得直推主分支，不得 force push。
12. 使用 `gh pr create` 创建 Pull Request；PR 正文应包括：
    - 背景与目标；
    - 本次变更范围；
    - 主要成果文件；
    - 关键业务规则和决策；
    - 质量检查结果；
    - 风险与影响；
    - 假设和待确认问题；
    - 回滚方式。
13. 不得自动合并 PR。
14. 最终向用户返回：分支名、提交号、PR 地址、成果摘要、待确认问题。
