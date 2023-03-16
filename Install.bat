@echo off
mkdir %LOCALAPPDATA%\nvim\
copy /Y init.lua %LOCALAPPDATA%\nvim\init.lua
xcopy /Y lua %LOCALAPPDATA%\nvim\lua\*
@echo Done!
timeout 2 /NOBREAK > NUL
