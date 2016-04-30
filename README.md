# Docker Compose Deployer
Simplified Blue Green Deployment for distributed applications with docker compose.

## How it works

This application dynamically generates a new application environment based on your docker-compose.yml. This allows an easy swap between environments (through an external router), resulting in a zero downtime deployment. Also, the combination of **docker compose** and the **router container (nginx)** allows you to run multiple internal services and expose them through a single endpoint.

## Setup
1. Install docker (http://docs.docker.com/engine/installation/)
2. Install docker-compose (https://docs.docker.com/compose/install/)
3. Define your application containers in docker-compose-template.yml or use the default one as demo. If you change or add new containers, don't forget to update router/nginx_template.conf
4. Generate a new environment with: `ruby gen_env.rb`
5. Start the application with `docker-compose up`
6. Access the internal (demo) services on `localhost/service1` and `localhost/service2`

## Options

#### gen_env.rb
- `-p #` desired port to generate a new docker-compose.yml. Default is 80.

## TODO

- Add container start/stop orchestration
- Add support to AWS ELB, to trigger the port changing when the new deployment is finished.
- Add hook to trigger generic router port swapping
- Add internal container communication, via Docker Network
- Add external hosts and containers support
- Add ngx_http_auth_request_module to router configuration, resulting in a closed api-like environment. Authentication must be passed to access the services.
- Refactor/Cleanup code
