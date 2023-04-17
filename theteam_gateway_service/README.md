# TheTeam Gateway

**TheTeam** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **TheTeam** today and take your team to the next level.

## A TheTeam Gateway Micro Service

## Getting Started
```bash
dart pub global activate protoc_plugin
dart pub get
```

#### Generate files
```bash
protoc --dart_out=grpc:lib/src/generated -Iprotos \
    protos/base_models.proto \
    protos/gate_models.proto \
    protos/gate_service.proto \
    protos/auth_service.proto \
    protos/auth_models.proto \
    protos/time_tracking_service.proto \
    protos/time_tracking_models.proto \
    protos/google/api/annotations.proto \
    protos/google/api/http.proto \
    protos/google/protobuf/struct.proto \
    protos/google/protobuf/descriptor.proto \
    protos/google/protobuf/empty.proto \
    protos/google/protobuf/timestamp.proto
dart run build_runner build -d
```