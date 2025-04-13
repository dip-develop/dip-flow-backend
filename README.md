# DIP Flow Backend

**DIP Flow** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **DIP Flow** today and take your team to the next level.

## A DIP Flow Backend with Micro Service Arhitecture

### Pre start

Install [Protocol Buffers](https://github.com/protocolbuffers/protobuf/releases) depends of your OS

```bash
dart pub global activate mono_repo
dart pub global activate melos
git submodule update --init --recursive
```

## Quick start

Linux and Mac

```bash
sh ./generate.sh
```

Windows

```bash
./generate.bat
```

#### VSCode config

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "user_service",
      "cwd": "packages/user_service",
      "request": "launch",
      "type": "dart",
      "program": "bin/server.dart"
    },
    {
      "name": "gateway_service",
      "cwd": "packages/gateway_service",
      "request": "launch",
      "type": "dart",
      "program": "bin/server.dart"
    },
    {
      "name": "activity_service",
      "cwd": "packages/activity_service",
      "request": "launch",
      "type": "dart",
      "program": "bin/server.dart"
    }
  ]
}
```
