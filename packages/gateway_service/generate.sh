#! /bin/bash

dart pub get
dart pub upgrade
dart pub global activate protoc_plugin

mkdir -p lib/src/generated
protoc --proto_path=protos/ --dart_out=grpc:lib/src/generated -Iprotos \
    base_models.proto \
    gate_models.proto \
    gate_service.proto \
    auth_models.proto \
    auth_service.proto \
    user_models.proto \
    user_service.proto \
    project_models.proto \
    project_service.proto \
    task_models.proto \
    task_service.proto \
    time_tracking_models.proto \
    time_tracking_service.proto \
    google/protobuf/empty.proto \
    google/protobuf/timestamp.proto
dart run build_runner build -d