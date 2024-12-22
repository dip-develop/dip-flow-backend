#! /bin/bash

git submodule update --init --recursive --remote
cd packages/
cd activity_service/
sh ./generate.sh
cd ../gateway_service/
sh ./generate.sh
cd ../user_service/
sh ./generate.sh