REM @ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0

SET GULP_TASK=%1
SET GULP_FILE=%2
CALL ".\node_modules\.bin\tsd.cmd" reinstall --save --overwrite
CALL ".\node_modules\.bin\bower.cmd" install
CALL ".\node_modules\.bin\gulp.cmd" %GULP_TASK% --gulpfile %GULP_FILE%

RMDIR /s /q ".\node_modules"