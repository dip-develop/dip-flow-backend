# Musmula Gateway

## A Musmula Gateway Micro Service

## Getting Started
```bash
dart pub global activate protoc_plugin
dart pub get
```

#### Generate files
```bash
dart pub global run protoc_plugin:protoc_plugin --dart_out=grpc:lib/src/generated -Iprotos protos/auth.proto
dart run build_runner build -d
```