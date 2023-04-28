# TheTeam Backend

**TheTeam** is the ultimate solution for team management. Whether you are a freelancer, a developer, an HR manager, or a headhunter, you can benefit from our powerful and user-friendly application that lets you track time, create reports, manage projects, and more. You can access our service from any device and any operating system, and enjoy our beautiful graphs that visualize your progress and performance. Plus, if you are an individual user or a small team, you can use our service for free forever. No hidden fees, no strings attached. Join **TheTeam** today and take your team to the next level.

## A TheTeam Backend with Micro Service Arhitecture

#### Get last datas
```bash
git submodule update --init --recursive --remote
```

#### VSCode config

```json
{

    "version": "0.2.0",
    "configurations": [
        {
            "name": "musmula_auth_service",
            "cwd": "musmula_auth_service",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "musmula_gateway_service",
            "cwd": "musmula_gateway_service",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "musmula_time_tracking_service",
            "cwd": "musmula_time_tracking_service",
            "request": "launch",
            "type": "dart"
        }       
    ]
}
```