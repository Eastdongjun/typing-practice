@echo off
chcp 65001 >nul
title 打字练习 - 安装到 S 盘

echo ============================================
echo   打字练习 - 一键安装到 S 盘
echo ============================================
echo.

:: 检查 S 盘是否存在
if not exist "S:\" (
    echo [错误] 未检测到 S 盘！请先确保 S 盘已挂载。
    pause
    exit /b 1
)

:: 进入 S 盘
S:
cd \

:: 如果已存在，先删除旧版本
if exist "S:\typing-practice\" (
    echo [信息] 检测到旧版本，正在删除...
    rmdir /s /q "S:\typing-practice"
)

echo [1/3] 正在从 GitHub 下载项目...
git clone https://github.com/Eastdongjun/typing-practice.git

if not exist "S:\typing-practice\" (
    echo [错误] 下载失败！请检查网络连接。
    pause
    exit /b 1
)

echo.
echo [2/3] 下载完成！
echo.

:: 直接打开即可使用（无需安装依赖）
echo [3/3] 正在启动打字练习...
start "" "S:\typing-practice\index.html"

echo.
echo ============================================
echo   安装完成！浏览器已打开打字练习。
echo   下次使用：直接打开 S:\typing-practice\index.html
echo ============================================
echo.
pause
