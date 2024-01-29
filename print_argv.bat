@ECHO OFF
SETLOCAL EnableDelayedExpansion
(SET \n=^
%=LF=%
)
SET i=0
FOR %%x IN (%0 %*) do (
  <NUL SET /p =!i!: %%~x!\n!
  SET /A i+=1
)
