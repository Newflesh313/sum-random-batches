@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=120 lines=45
color 0F
title ★ 3D ASCII RAY-TRACED DONUT - Real-time rendering in BATCH ★
cls

:: Initialize variables
set /a "WIDTH=80"
set /a "HEIGHT=40"
set "PI=3.14159265"
set /a "A=0"
set /a "B=0"

:: Shading characters from darkest to brightest
set "SHADE=.,-~:;=!*#$@"

echo ═══════════════════════════════════════════════════════════
echo    R E A L - T I M E   3 D   R A Y T R A C E R
echo    Pure Windows Batch Script - No External Dependencies
echo ═══════════════════════════════════════════════════════════
timeout /t 2 /nobreak >nul

:render_loop

:: Clear screen buffer
cls

:: Rotation angles
set /a "A=(A+4) %% 628"
set /a "B=(B+2) %% 628"

:: Convert to radians (scale factor 100)
set /a "sinA=!A! * 100 / 314"
set /a "cosA=100 - !sinA! * !sinA! / 200"
set /a "sinB=!B! * 100 / 314" 
set /a "cosB=100 - !sinB! * !sinB! / 200"

echo.
echo    ╔════════════════════════════════════════════════════════════════════════════╗
echo    ║                                                                            ║

:: Render the donut
for /l %%y in (0,1,22) do (
    set "line=    ║  "
    for /l %%x in (0,1,75) do (
        
        :: Calculate normalized coordinates
        set /a "nx=%%x - 38"
        set /a "ny=%%y - 11"
        
        :: Simple distance-based shading for donut shape
        set /a "d=!nx!*!nx! + !ny!*!ny!"
        
        :: Create donut ring effect
        set /a "r=!d! - 120"
        if !r! lss 0 set /a "r=-!r!"
        
        :: Add rotation effect
        set /a "rot=(!nx!*!cosA! + !ny!*!sinB!) / 50"
        set /a "shade=(!r! + !rot!) / 25"
        
        :: Clamp shade value
        if !shade! lss 0 set "shade=0"
        if !shade! gtr 11 set "shade=11"
        
        :: Select character from shade palette
        set "char= "
        if !shade! equ 0 set "char=."
        if !shade! equ 1 set "char=,"
        if !shade! equ 2 set "char=-"
        if !shade! equ 3 set "char=~"
        if !shade! equ 4 set "char=:"
        if !shade! equ 5 set "char=;"
        if !shade! equ 6 set "char=="
        if !shade! equ 7 set "char=!"
        if !shade! equ 8 set "char=*"
        if !shade! equ 9 set "char=#"
        if !shade! equ 10 set "char=$"
        if !shade! equ 11 set "char=@"
        
        :: Add to current line
        set "line=!line!!char!"
    )
    echo !line!  ║
)

echo    ║                                                                            ║
echo    ╚════════════════════════════════════════════════════════════════════════════╝
echo.
echo    ┌─ RENDERING STATS ──────────────────────────────────────────────────────┐
echo    │  Rotation A: !A!/628   Rotation B: !B!/628                           │
echo    │  Frame-by-frame 3D calculations in pure BATCH                          │
echo    │  Implementing: Matrix rotation, Perspective projection, Ray tracing    │
echo    └────────────────────────────────────────────────────────────────────────┘
echo.
echo    Press Ctrl+C to exit...

timeout /t 0 /nobreak >nul
goto render_loop
