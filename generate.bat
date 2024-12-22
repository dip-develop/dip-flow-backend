@echo off

cd "packages/"
cd "activity_service/"
"%CD%\generate.bat"
cd "../gateway_service/"
"%CD%\generate.bat"
cd "../user_service/"
"%CD%\generate.bat"