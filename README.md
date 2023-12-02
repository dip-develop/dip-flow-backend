# Collabster Backend

**Collabster** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **Collabster** today and take your team to the next level.

## A Collabster Backend with Micro Service Arhitecture

## Quick start

```bash
sh ./generate.sh
```

## Or manual getting Started

### Get last datas

```bash
git submodule update --init --recursive --remote
```

#### VSCode config

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "user_service",
            "cwd": "user_service",
            "request": "launch",
            "type": "dart",
            "program": "bin/server.dart"
        },
        {
            "name": "gateway_service",
            "cwd": "gateway_service",
            "request": "launch",
            "type": "dart",
            "program": "bin/server.dart"
        },
        {
            "name": "activity_service",
            "cwd": "activity_service",
            "request": "launch",
            "type": "dart",
            "program": "bin/server.dart"
        }
    ]
}
```
