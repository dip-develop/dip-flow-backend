# TheTeam Time Tracking

**TheTeam** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **TheTeam** today and take your team to the next level.

## A TheTeam Time Tracking Micro Service

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