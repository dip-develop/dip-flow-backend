#! /bin/bash



cp -r protos packages/activity_service/protos
cd packages/activity_service/
sh ./generate.sh
# rm -r packages/activity_service/protos
cd ../../

cp -r protos packages/gateway_service/protos
cd packages/gateway_service/
sh ./generate.sh
# rm -r packages/gateway_service/protos
cd ../../

cp -r protos packages/user_service/protos
cd packages/user_service/
sh ./generate.sh
# rm -r packages/user_service/protos
cd ../../