@echo off
mkdir %USERPROFILE%\.config\
mkdir %USERPROFILE%\.config\nvim
copy /Y init.lua %USERPROFILE%\.config\nvim\init.lua
xcopy /Y lua %USERPROFILE%\.config\nvim\lua\*
@echo Done!
timeout 2 /NOBREAK > NUL
