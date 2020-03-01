@echo off & setlocal enableextensions disabledelayedexpansion
set s1=%~1
set s2=%~2
if %s1%==%s2% (echo 1) else (echo 0)
