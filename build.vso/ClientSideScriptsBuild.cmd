REM @ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SET me=%~n0
SET parent=%~dp0

SET GULP_TASK=%1
SET GULP_FILE=%2
SET NODEMODULES=.\node_modules\.bin\
CALL %NODE_MODULES%gulp.cmd %GULP_TASK% --gulpfile %GULP_FILE%
CALL %NODE_MODULES%bower.cmd install
CALL %NODE_MODULES%tsd.cmd reinstall --save --overwrite
