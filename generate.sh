#! /bin/bash

dart pub global activate melos
melos bootstrap

cd packages/activity_service
sh generate.sh
cd ../packages/gateway_service
sh generate.sh
cd ../packages/user_service
sh generate.sh