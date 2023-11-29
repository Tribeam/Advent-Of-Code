@echo off


echo Tribeam's Advent Of Code Platform Thingy
set /p "year=Year: "
set /p "day=Day: "
set /p "part=Part: "
love2d\love.exe "" %year% %day% %part%