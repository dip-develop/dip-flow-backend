@echo off

dart "pub" "global" "activate" "protoc_plugin"
dart "pub" "get"
dart "pub" "upgrade"
mkdir "lib\src\generated"
protoc "--dart_out=grpc:lib\src\generated" "-Iprotos" "protos\base_models.proto" "protos\auth_service.proto" "protos\auth_models.proto" "protos\user_service.proto" "protos\user_models.proto" "protos\google\api\annotations.proto" "protos\google\api\http.proto" "protos\google\protobuf\struct.proto" "protos\google\protobuf\descriptor.proto" "protos\google\protobuf\empty.proto" "protos\google\protobuf\timestamp.proto"
dart "run" "build_runner" "build" "-d"