# Collabster User

**Collabster** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **Collabster** today and take your team to the next level.

## A Collabster User Micro Service

## Quick start

Linux and Mac

```bash
sh ./generate.sh
```

Windows

```cmd
./generate.bat
```

## Or manual getting Started

```bash
dart pub global activate protoc_plugin
dart pub get
```

### Generate files

```bash
mkdir -p lib/src/generated
protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/base_models.proto \
    protos/auth_service.proto \
    protos/auth_models.proto \
    protos/user_service.proto \
    protos/user_models.proto \
    protos/google/api/annotations.proto \
    protos/google/api/http.proto \
    protos/google/protobuf/struct.proto \
    protos/google/protobuf/descriptor.proto \
    protos/google/protobuf/empty.proto \
    protos/google/protobuf/timestamp.proto
dart run build_runner build -d
```
