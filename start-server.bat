@echo off
chcp 65001 > nul

REM 配置参数
set PORT=8080
set PYTHON_CMD=python

REM 检查端口是否被占用
netstat -ano | findstr :%PORT% > nul
if %errorlevel% equ 0 (
    echo 端口 %PORT% 已被占用，正在清理...
    REM 查找占用端口的进程ID
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%PORT%') do (
        set PID=%%a
        REM 终止占用端口的进程
        taskkill /F /PID %%a > nul 2>&1
        if errorlevel 1 (
            echo 终止进程失败，请手动清理
        ) else (
            echo 已成功终止占用端口 %PORT% 的进程 (PID: %%a)
        )
        goto start_server
    )
)

:start_server
REM 启动本地服务器
echo 正在启动本地服务器，端口: %PORT%
echo 项目路径: %cd%
echo 访问地址: http://localhost:%PORT%
echo.

REM 使用 Python 启动 HTTP 服务器
%PYTHON_CMD% -m http.server %PORT%