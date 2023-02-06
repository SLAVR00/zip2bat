@echo off
set ext=%~x1
set fn=%~n1
IF NOT %ext%==.zip (
  echo I want the zip file.
  echo press any key to exit...
  pause > NUL
  exit
)
set out_bat="extract_%fn%.bat"
set out_b64="base64_%fn%"
( echo @echo off
  echo cd /d %%~dp0
  echo set fn=%%~n0
  echo if exist %%fn:extract_=%% ^(
  echo echo A decompressed folder exists.
  echo pause
  echo exit
  echo ^)
  echo set fileName="%%fn:extract_=%%_tmp.zip"
  echo certutil -decode "%%~f0" %%fileName%%
  echo call powershell -command "Expand-Archive ""%%fileName%%"" ""%%fileName:_tmp.zip=%%"""
  echo del %%fileName%%
  echo echo extraction process has completed.
  echo echo press any key to exit...
  echo timeout /t 5 ^> nul
  echo exit /b %%errorlevel%%
) > %out_bat%
certutil -encode "%~1" %out_b64%
copy /b %out_bat% + %out_b64%
del %out_b64%
