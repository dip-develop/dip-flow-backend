#! /bin/bash

cp -r protos packages/activity_service/protos
cp -r protos packages/gateway_service/protos
cp -r protos packages/user_service/protos

sh ./packages/activity_service/generate.sh
sh ./packages/gateway_service/generate.sh
sh ./packages/user_service/generate.sh

rm -r packages/activity_service/protos
rm -r packages/gateway_service/protos
rm -r packages/user_service/protos