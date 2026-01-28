@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=140 lines=48
color 0E
title ◆◆◆ MANDELBROT SET FRACTAL EXPLORER - Deep Zoom Capability ◆◆◆
cls

:: Initial view parameters
set /a "centerX=-50"
set /a "centerY=0"
set /a "zoom=100"
set /a "maxIter=20"

echo ══════════════════════════════════════════════════════════════════════
echo    M A N D E L B R O T   S E T   E X P L O R E R
echo    Real-time fractal rendering in Windows Batch
echo ══════════════════════════════════════════════════════════════════════
timeout /t 2 /nobreak >nul

:fractal_loop

cls
echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗

:: Render the Mandelbrot set
for /l %%y in (0,1,36) do (
    set "line=║ "
    
    for /l %%x in (0,1,129) do (
        
        :: Map screen coordinates to complex plane
        set /a "x0=((%%x - 65) * 300 / !zoom!) + !centerX!"
        set /a "y0=((%%y - 18) * 300 / !zoom!) + !centerY!"
        
        :: Initialize iteration
        set /a "x=0"
        set /a "y=0"
        set /a "iter=0"
        
        :: Mandelbrot iteration (simplified for batch)
        for /l %%i in (1,1,!maxIter!) do (
            set /a "xx=!x! * !x! / 100"
            set /a "yy=!y! * !y! / 100"
            set /a "sum=!xx! + !yy!"
            
            if !sum! lss 400 (
                set /a "yt=2 * !x! * !y! / 100 + !y0!"
                set /a "x=!xx! - !yy! + !x0!"
                set /a "y=!yt!"
                set /a "iter=%%i"
            )
        )
        
        :: Map iteration to character
        set "char= "
        if !iter! equ 1 set "char=."
        if !iter! equ 2 set "char=,"
        if !iter! equ 3 set "char=:"
        if !iter! equ 4 set "char=;"
        if !iter! equ 5 set "char=+"
        if !iter! equ 6 set "char=*"
        if !iter! equ 7 set "char=x"
        if !iter! equ 8 set "char=o"
        if !iter! equ 9 set "char=O"
        if !iter! equ 10 set "char=0"
        if !iter! equ 11 set "char=X"
        if !iter! equ 12 set "char=#"
        if !iter! equ 13 set "char=%"
        if !iter! equ 14 set "char=&"
        if !iter! equ 15 set "char=@"
        if !iter! equ 16 set "char=▓"
        if !iter! equ 17 set "char=▒"
        if !iter! equ 18 set "char=░"
        if !iter! equ 19 set "char=█"
        if !iter! equ 20 set "char=█"
        
        set "line=!line!!char!"
    )
    echo !line! ║
)

echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌─ FRACTAL PARAMETERS ──────────────────────────────────────────────────────────────────┐
echo │  Center: (!centerX!/100, !centerY!/100)   Zoom: !zoom!x   Max Iterations: !maxIter!    │
echo │  Auto-zooming into fractal... Each frame recalculates 4,680 complex points            │
echo └───────────────────────────────────────────────────────────────────────────────────────┘
echo Press Ctrl+C to exit

:: Auto-zoom animation
set /a "zoom=!zoom! + 5"
if !zoom! gtr 500 (
    set /a "zoom=100"
    set /a "centerX=!centerX! - 10"
)

if !centerX! lss -100 set /a "centerX=-50"

timeout /t 0 /nobreak >nul
goto fractal_loop
