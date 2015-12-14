ECHO %CD%

CALL ".\node_modules\.bin\bower.cmd" install
CALL ".\node_modules\.bin\tsd.cmd" install
