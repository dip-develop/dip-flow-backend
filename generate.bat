@echo off

xcopy /s /e /y "protos" "packages\activity_service\protos\"
cd "packages\activity_service\"
call "generate.bat"
::  del /s /q "packages\activity_service\protos"
cd "..\..\"

xcopy /s /e /y "protos" "packages\gateway_service\protos\"
cd "packages\gateway_service\"
call "generate.bat"
::  del /s /q "packages\gateway_service\protos"
cd "..\..\"

xcopy /s /e /y "protos" "packages\user_service\protos\"
cd "packages\user_service\"
call "generate.bat"
::  del /s /q "packages\user_service\protos"
cd "..\..\"