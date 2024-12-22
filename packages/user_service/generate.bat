@echo off

dart "pub" "global" "activate" "protoc_plugin"
dart "pub" "get"
dart "pub" "upgrade"
mkdir "lib\src\generated"
protoc "--proto_path=../../protos/" "--dart_out=grpc:lib/src/generated" "-Iprotos" "base_models.proto" "auth_service.proto" "auth_models.proto" "user_service.proto" "user_models.proto" "google/protobuf/empty.proto" "google/protobuf/timestamp.proto"
dart "run" "build_runner" "build" "-d"