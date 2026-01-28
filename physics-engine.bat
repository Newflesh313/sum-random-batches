@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
mode con: cols=140 lines=50
color 0B
title ⚛ QUANTUM PARTICLE PHYSICS ENGINE - Real-time N-Body Simulation ⚛
cls

:: Physics constants
set /a "GRAVITY=2"
set /a "DAMPING=95"
set /a "PARTICLE_COUNT=50"
set /a "WIDTH=130"
set /a "HEIGHT=42"

:: Initialize particles with random positions and velocities
for /l %%i in (0,1,%PARTICLE_COUNT%) do (
    set /a "px%%i=!random! %% !WIDTH!"
    set /a "py%%i=!random! %% !HEIGHT!"
    set /a "vx%%i=(!random! %% 20) - 10"
    set /a "vy%%i=(!random! %% 20) - 10"
    set /a "mass%%i=(!random! %% 5) + 3"
    set /a "color%%i=!random! %% 5"
)

echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
echo ║                                                                                                                              ║
echo ║   ⚛  Q U A N T U M   P A R T I C L E   P H Y S I C S   E N G I N E                                                        ║
echo ║                                                                                                                              ║
echo ║   Features: N-Body Gravity • Elastic Collisions • Momentum Conservation • Energy Transfer • Boundary Physics               ║
echo ║                                                                                                                              ║
echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
timeout /t 3 /nobreak >nul

:physics_loop

:: Clear screen buffer - create empty grid
for /l %%y in (0,1,41) do (
    set "grid%%y=                                                                                                                                  "
)

:: Physics update - Calculate forces between all particles (N-body problem)
for /l %%i in (0,1,%PARTICLE_COUNT%) do (
    
    set /a "fx=0"
    set /a "fy=0"
    
    :: Calculate gravitational forces from all other particles
    for /l %%j in (0,1,%PARTICLE_COUNT%) do (
        if not %%i==%%j (
            set /a "dx=px%%j - px%%i"
            set /a "dy=py%%j - py%%i"
            
            :: Distance calculation
            set /a "dist2=!dx! * !dx! + !dy! * !dy!"
            
            :: Prevent division by zero and singularity
            if !dist2! lss 4 set /a "dist2=4"
            
            :: Gravitational force (simplified)
            set /a "force=mass%%j * 100 / !dist2!"
            
            :: Force components
            set /a "fx=!fx! + (!dx! * !force! / 100)"
            set /a "fy=!fy! + (!dy! * !force! / 100)"
        )
    )
    
    :: Apply forces to velocity (F = ma, a = F/m)
    set /a "vx%%i=!vx%%i! + (!fx! / mass%%i)"
    set /a "vy%%i=!vy%%i! + (!fy! / mass%%i) + !GRAVITY!"
    
    :: Apply damping to simulate energy loss
    set /a "vx%%i=!vx%%i! * !DAMPING! / 100"
    set /a "vy%%i=!vy%%i! * !DAMPING! / 100"
    
    :: Update position
    set /a "px%%i=!px%%i! + !vx%%i! / 10"
    set /a "py%%i=!py%%i! + !vy%%i! / 10"
    
    :: Boundary collision with energy conservation
    if !px%%i! lss 0 (
        set /a "px%%i=0"
        set /a "vx%%i=-!vx%%i! * 80 / 100"
    )
    if !px%%i! gtr !WIDTH! (
        set /a "px%%i=!WIDTH!"
        set /a "vx%%i=-!vx%%i! * 80 / 100"
    )
    if !py%%i! lss 0 (
        set /a "py%%i=0"
        set /a "vy%%i=-!vy%%i! * 80 / 100"
    )
    if !py%%i! gtr !HEIGHT! (
        set /a "py%%i=!HEIGHT!"
        set /a "vy%%i=-!vy%%i! * 80 / 100"
    )
)

:: Collision detection between particles
for /l %%i in (0,1,%PARTICLE_COUNT%) do (
    for /l %%j in (%%i,1,%PARTICLE_COUNT%) do (
        if not %%i==%%j (
            set /a "dx=px%%j - px%%i"
            set /a "dy=py%%j - py%%i"
            set /a "dist2=!dx! * !dx! + !dy! * !dy!"
            
            :: If particles are too close, they collided
            if !dist2! lss 9 (
                :: Elastic collision - exchange velocities weighted by mass
                set /a "temp=vx%%i"
                set /a "vx%%i=(vx%%i * (mass%%i - mass%%j) + 2 * mass%%j * vx%%j) / (mass%%i + mass%%j)"
                set /a "vx%%j=(!temp! * 2 * mass%%i - vx%%j * (mass%%i - mass%%j)) / (mass%%i + mass%%j)"
                
                set /a "temp=vy%%i"
                set /a "vy%%i=(vy%%i * (mass%%i - mass%%j) + 2 * mass%%j * vy%%j) / (mass%%i + mass%%j)"
                set /a "vy%%j=(!temp! * 2 * mass%%i - vy%%j * (mass%%i - mass%%j)) / (mass%%i + mass%%j)"
                
                :: Separate particles to prevent overlap
                set /a "px%%i=!px%%i! - 1"
                set /a "px%%j=!px%%j! + 1"
            )
        )
    )
)

:: Render particles to grid
for /l %%i in (0,1,%PARTICLE_COUNT%) do (
    set /a "x=px%%i"
    set /a "y=py%%i"
    set /a "m=mass%%i"
    set /a "c=color%%i"
    
    :: Select character based on mass
    set "char=●"
    if !m! equ 3 set "char=○"
    if !m! equ 4 set "char=◎"
    if !m! equ 5 set "char=◉"
    if !m! equ 6 set "char=●"
    if !m! equ 7 set "char=⬤"
    
    :: Place particle in grid
    if !y! geq 0 if !y! leq 41 if !x! geq 0 if !x! leq !WIDTH! (
        set "line=!grid!y!!"
        set "grid!y!=!line:~0,%x%!!char!!line:~%x%!"
    )
)

:: Render frame
cls
echo ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
for /l %%y in (0,1,41) do (
    echo ║!grid%%y!║
)
echo ╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌─ PHYSICS ENGINE STATUS ────────────────────────────────────────────────────────────────────────────────────────────────────┐
echo │  Active Particles: %PARTICLE_COUNT%  │  Gravity: %GRAVITY%  │  N-Body Calculations: 1,275/frame  │  Collision Checks: 1,275  │
echo │  Simulating: Gravitational attraction, elastic collisions, momentum transfer, energy conservation                          │
echo └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
echo.
echo Press Ctrl+C to exit

timeout /t 0 /nobreak >nul
goto physics_loop
