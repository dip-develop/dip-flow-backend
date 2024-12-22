@echo off

git "submodule" "update" "--init" "--recursive" "--remote"
cd "packages/"
cd "activity_service/"
"%CD%\generate.bat"
cd "../gateway_service/"
"%CD%\generate.bat"
cd "../user_service/"
"%CD%\generate.bat"