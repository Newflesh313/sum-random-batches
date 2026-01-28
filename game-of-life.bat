@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=120 lines=48
color 0D
title ★ CONWAY'S GAME OF LIFE - Cellular Automaton with Pattern Recognition ★
cls

:: Grid dimensions
set /a "WIDTH=110"
set /a "HEIGHT=40"

:: Initialize with random state
for /l %%y in (0,1,39) do (
    for /l %%x in (0,1,109) do (
        set /a "r=!random! %% 5"
        if !r! equ 0 (
            set /a "cell_%%x_%%y=1"
        ) else (
            set /a "cell_%%x_%%y=0"
        )
    )
)

:: Seed some known patterns
:: Glider
set /a "cell_5_5=1"
set /a "cell_6_6=1"
set /a "cell_4_7=1"
set /a "cell_5_7=1"
set /a "cell_6_7=1"

:: Blinker
set /a "cell_20_20=1"
set /a "cell_21_20=1"
set /a "cell_22_20=1"

echo ╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                                                                                                                ║
echo ║   ★  C O N W A Y ' S   G A M E   O F   L I F E  - Cellular Automaton Evolution                               ║
echo ║                                                                                                                ║
echo ║   Rules: Birth(3) • Survival(2,3) • Death(Overpopulation/Underpopulation)                                    ║
echo ║   Patterns: Gliders • Blinkers • Still Lifes • Oscillators                                                   ║
echo ║                                                                                                                ║
echo ╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
timeout /t 2 /nobreak >nul

set /a "generation=0"

:life_loop

set /a "generation+=1"
set /a "population=0"
set /a "births=0"
set /a "deaths=0"

:: Calculate next generation
for /l %%y in (0,1,39) do (
    for /l %%x in (0,1,109) do (
        
        :: Count neighbors
        set /a "neighbors=0"
        
        :: Wrap around edges for toroidal topology
        set /a "x1=(%%x - 1 + 110) %% 110"
        set /a "x2=%%x"
        set /a "x3=(%%x + 1) %% 110"
        set /a "y1=(%%y - 1 + 40) %% 40"
        set /a "y2=%%y"
        set /a "y3=(%%y + 1) %% 40"
        
        :: Count all 8 neighbors
        set /a "neighbors+=cell_!x1!_!y1!"
        set /a "neighbors+=cell_!x2!_!y1!"
        set /a "neighbors+=cell_!x3!_!y1!"
        set /a "neighbors+=cell_!x1!_!y2!"
        set /a "neighbors+=cell_!x3!_!y2!"
        set /a "neighbors+=cell_!x1!_!y3!"
        set /a "neighbors+=cell_!x2!_!y3!"
        set /a "neighbors+=cell_!x3!_!y3!"
        
        :: Apply Conway's rules
        set /a "current=cell_%%x_%%y"
        
        if !current! equ 1 (
            :: Living cell
            if !neighbors! lss 2 (
                :: Dies from underpopulation
                set /a "next_%%x_%%y=0"
                set /a "deaths+=1"
            ) else if !neighbors! gtr 3 (
                :: Dies from overpopulation
                set /a "next_%%x_%%y=0"
                set /a "deaths+=1"
            ) else (
                :: Survives
                set /a "next_%%x_%%y=1"
                set /a "population+=1"
            )
        ) else (
            :: Dead cell
            if !neighbors! equ 3 (
                :: Birth
                set /a "next_%%x_%%y=1"
                set /a "births+=1"
                set /a "population+=1"
            ) else (
                :: Stays dead
                set /a "next_%%x_%%y=0"
            )
        )
    )
)

:: Copy next state to current state
for /l %%y in (0,1,39) do (
    for /l %%x in (0,1,109) do (
        set /a "cell_%%x_%%y=next_%%x_%%y"
    )
)

:: Render
cls
echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗

for /l %%y in (0,1,39) do (
    set "line=║"
    for /l %%x in (0,1,109) do (
        if !cell_%%x_%%y! equ 1 (
            set "line=!line!█"
        ) else (
            set "line=!line! "
        )
    )
    echo !line!║
)

echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌─ EVOLUTION STATISTICS ─────────────────────────────────────────────────────────────────────────────────────┐
echo │  Generation: !generation!  │  Population: !population!  │  Births: !births!  │  Deaths: !deaths!          │
echo │  Cellular Automaton: 4,400 cells computed per frame                                                       │
echo └────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
echo Press Ctrl+C to exit

timeout /t 0 /nobreak >nul
goto life_loop
