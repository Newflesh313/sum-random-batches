@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=160 lines=50
color 0A
title ▓▒░ MATRIX DIGITAL RAIN SIMULATOR - Advanced Terminal Graphics ░▒▓
cls

:: Initialize 160 columns of rain
for /l %%i in (0,1,159) do (
    set /a "pos%%i=!random! %% 50"
    set /a "speed%%i=!random! %% 3 + 1"
    set /a "len%%i=!random! %% 15 + 5"
)

:matrix_loop

:: Create empty buffer
for /l %%y in (0,1,49) do set "line%%y= "

:: Update and render each column
for /l %%x in (0,1,159) do (
    
    :: Get current position and speed
    set /a "p=pos%%x"
    set /a "s=speed%%x"
    set /a "l=len%%x"
    
    :: Update position
    set /a "pos%%x=!p! + !s!"
    
    :: Reset if off screen
    if !p! gtr 55 (
        set /a "pos%%x=!random! %% 10 - 10"
        set /a "len%%x=!random! %% 15 + 5"
    )
    
    :: Draw the trail
    for /l %%t in (0,1,!l!) do (
        set /a "y=!p! - %%t"
        
        if !y! geq 0 if !y! lss 50 (
            :: Generate random character
            set /a "char=!random! %% 94 + 33"
            
            :: Convert to character (limited set for batch)
            set "c=█"
            set /a "r=!random! %% 26"
            if !r! equ 0 set "c=0"
            if !r! equ 1 set "c=1"
            if !r! equ 2 set "c=2"
            if !r! equ 3 set "c=3"
            if !r! equ 4 set "c=4"
            if !r! equ 5 set "c=5"
            if !r! equ 6 set "c=6"
            if !r! equ 7 set "c=7"
            if !r! equ 8 set "c=8"
            if !r! equ 9 set "c=9"
            if !r! equ 10 set "c=ﾊ"
            if !r! equ 11 set "c=ﾐ"
            if !r! equ 12 set "c=ｼ"
            if !r! equ 13 set "c=ｦ"
            if !r! equ 14 set "c=Z"
            if !r! equ 15 set "c=日"
            if !r! equ 16 set "c=╋"
            if !r! equ 17 set "c=╬"
            if !r! equ 18 set "c=║"
            if !r! equ 19 set "c=╗"
            if !r! equ 20 set "c=╚"
            if !r! equ 21 set "c=╝"
            if !r! equ 22 set "c=▓"
            if !r! equ 23 set "c=▒"
            if !r! equ 24 set "c=░"
            if !r! equ 25 set "c=█"
            
            :: Brightest at head
            if %%t equ 0 set "c=█"
            
            :: Set character at position
            set "temp=!line!y!!"
            set "line!y!=!temp:~0,%%x!!c!!temp:~%%x!"
        )
    )
)

:: Render frame
cls
for /l %%y in (0,1,49) do echo !line%%y!

timeout /t 0 /nobreak >nul
goto matrix_loop
