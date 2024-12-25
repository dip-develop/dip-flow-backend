@echo off

xcopy /s /e /y "protos" "packages\activity_service\protos\"
cmd /c "packages\activity_service\generate.bat"
::  del /s /q "packages\activity_service\protos"

xcopy /s /e /y "protos" "packages\gateway_service\protos\"
cmd /c "packages\gateway_service\generate.bat"
::  del /s /q "packages\gateway_service\protos"

xcopy /s /e /y "protos" "packages\user_service\protos\"
cmd /c "packages\user_service\generate.bat"
::  del /s /q "packages\user_service\protos"