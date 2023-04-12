# TheTeam Gateway

## A TheTeam Gateway Micro Service

## Getting Started
```bash
dart pub global activate protoc_plugin
dart pub get
```

#### Generate files
```bash
protoc --dart_out=grpc:lib/src/generated -Iprotos \
    ../../protos/gate_service.proto \
    ../../protos/auth_models.proto \
    ../../protos/time_tracking_models.proto \
    ../../protos/google/api/annotations.proto \
    ../../protos/google/api/http.proto \
    ../../protos/google/protobuf/struct.proto \
    ../../protos/google/protobuf/descriptor.proto \
    ../../protos/google/protobuf/empty.proto \
    ../../protos/google/protobuf/timestamp.proto
dart run build_runner build -d
```