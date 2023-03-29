# Musmula Auth

## A Musmula Auth Micro Service

## Getting Started
```bash
dart pub global activate protoc_plugin
bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh) --sync
dart pub get
```

#### Generate files
```bash
dart pub global run protoc_plugin:protoc_plugin --dart_out=grpc:lib/src/generated -Iprotos protos/auth.proto
dart run build_runner build -d
```