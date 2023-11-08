#! /bin/bash

dart pub global activate protoc_plugin
bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh) --sync --quiet
dart pub get

mkdir -p lib/src/generated
protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/base_models.proto \
    protos/project_service.proto \
    protos/project_models.proto \
    protos/task_service.proto \
    protos/task_models.proto \
    protos/time_tracking_models.proto \
    protos/time_tracking_service.proto \
    protos/google/api/annotations.proto \
    protos/google/api/http.proto \
    protos/google/protobuf/struct.proto \
    protos/google/protobuf/descriptor.proto \
    protos/google/protobuf/empty.proto \
    protos/google/protobuf/timestamp.proto
dart run build_runner build -d