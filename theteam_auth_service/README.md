# TheTeam Auth

## A TheTeam Auth Micro Service

## Getting Started
```bash
dart pub global activate protoc_plugin
bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh) --sync
dart pub get
```

#### Generate files
```bash
protoc --dart_out=grpc:lib/src/generated -Iprotos \
    ../protos/auth_service.proto \
    ../protos/auth_models.proto \
    ../protos/google/api/annotations.proto \
    ../protos/google/api/http.proto \
    ../protos/google/protobuf/struct.proto \
    ../protos/google/protobuf/descriptor.proto \
    ../protos/google/protobuf/empty.proto \
    ../protos/google/protobuf/timestamp.proto
dart run build_runner build -d
```