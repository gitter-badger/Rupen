@REM CALL npm install -g bower tsd gulp
CALL npm install
CALL bower install
@REM CALL tsd install
@REM CALL tsd install node --resolve --save --overwrite
CALL tsd reinstall --save --overwrite