# ⌨️ 打字练习 · Typing Practice

Desktop typing practice tool with finger training, poetry learning, and multi-role support.

桌面端打字练习工具，支持指法训练、古诗文练习、多角色管理。

---

## ✨ Features · 功能

| Feature · 功能 | Description · 描述 |
|---|---|
| **5 Practice Modes** | English words, Quotes, Code, Chinese, Finger training |
| **5 种练习模式** | 英文词、名言、代码、中文、指法训练 |
| **🎨 10 Skins** | Dark / Light / Forest / Ocean / Sakura / Cyberpunk / Gray / Sunset / Mint / Midnight |
| **🎨 10 套皮肤** | 深色 / 浅色 / 森林绿 / 海洋蓝 / 樱花粉 / 赛博朋克 / 极简灰 / 日落 / 薄荷 / 午夜紫 |
| **⏰ Auto Theme** | Switches dark/light automatically based on system time |
| **⏰ 自动主题** | 根据系统时间自动切换深色/浅色 |
| **🖥️ Responsive** | Fluid scaling from 1366px laptops to 4K displays |
| **🖥️ 桌面自适应** | 1366px 笔记本到 4K 大屏流畅适配 |
| **⌨️ Finger Keyboard** | Visual heatmap keyboard, Mac/Windows layout toggle |
| **⌨️ 指法键盘** | 可视化键盘热区，Mac/Windows 布局切换 |
| **📊 Real-time Stats** | WPM, accuracy, progress |
| **📊 实时统计** | 速度（字/分）、准确率、进度 |

---

## 📥 Download · 下载

> **👉 [Latest Release · 最新版下载](https://github.com/Eastdongjun/typing-practice/releases/latest)**

| Platform · 平台 | Architecture · 架构 | File · 文件 |
|---|---|---|
| 🍎 macOS | Apple Silicon (M1-M4) | `TypingPractice-*-AppleSilicon-arm64.dmg` |
| 🍎 macOS | Intel (x64) | `TypingPractice-*-Intel-x64.dmg` |
| 🪟 Windows | x64 (Win10 / Win11) | `TypingPractice-*-Windows-x64-Setup.exe` |

> ⚠️ Windows 32-bit (x86) is not supported — Electron no longer provides 32-bit binaries.

---

## 🚀 Development · 开发

```bash
git clone https://github.com/Eastdongjun/typing-practice.git
cd typing-practice
npm install
npm start          # Run in dev mode · 开发运行
npm run build:mac  # Build for macOS · 构建 macOS
npm run build:win  # Build for Windows · 构建 Windows
```

---

## 🗺️ Roadmap · 路线图

| Phase · 阶段 | Content · 内容 |
|---|---|
| ✅ Phase 1 | Theme system + Desktop responsive · 主题系统 + 桌面响应式 |
| 🔜 Phase 2 | User system (Student/Parent/Teacher roles) + Ancient poetry · 用户系统 + 古诗文 |
| 🔜 Phase 3 | Parent dashboard + Analytics · 家长监控看板 + 统计分析 |

---

## 🛠️ Tech Stack · 技术栈

- Electron 35
- Vanilla HTML/CSS/JS (zero framework) · 纯 HTML/CSS/JS（无框架）
- CSS Variable theme system · CSS 变量主题系统
- electron-builder cross-platform packaging · 跨平台打包

---

## 📄 License

MIT
