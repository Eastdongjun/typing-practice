# ⌨️ 打字练习

桌面端打字练习工具，支持指法训练、古诗文练习、多角色管理。

## ✨ 功能

- **5 种练习模式**：英文词、名言、代码、中文、指法训练
- **🎨 10 套皮肤**：深色/浅色/森林绿/海洋蓝/樱花粉/赛博朋克/极简灰/日落/薄荷/午夜紫
- **⏰ 自动主题**：根据系统时间自动切换深色/浅色
- **🖥️ 桌面自适应**：1366px 笔记本到 4K 大屏流畅适配
- **⌨️ 指法键盘**：可视化键盘热区，Mac/Windows 布局切换
- **📊 实时统计**：速度（字/分）、准确率、进度

## 📥 下载安装

### Windows（Win10 / Win11 64位）

下载 `打字练习 Setup 1.0.0.exe`，双击安装。

### macOS（Apple Silicon）

下载 `打字练习-1.0.0-arm64.dmg`，拖入 Applications。

## 🚀 开发

```bash
git clone https://github.com/Eastdongjun/typing-practice.git
cd typing-practice
npm install
npm start          # 开发运行
npm run build:mac  # 构建 macOS
npm run build:win  # 构建 Windows
```

## 🗺️ 路线图

| 阶段 | 内容 |
|------|------|
| ✅ Phase 1 | 主题系统 + 桌面响应式适配 |
| 🔜 Phase 2 | 用户系统（学生/家长/教师角色）+ 古诗文内容 |
| 🔜 Phase 3 | 家长监控看板 + 统计分析 |

## 🛠️ 技术栈

- Electron 35
- 纯 HTML/CSS/JS（无框架依赖）
- CSS 变量主题系统
- electron-builder 跨平台打包

## 📄 License

MIT
