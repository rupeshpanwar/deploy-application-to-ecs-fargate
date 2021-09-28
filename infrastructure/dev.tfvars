
environment = "development"

remote_state_key = "DEV/platform.tfstate"
remote_state_bucket = "devops-dev-tfstate"

# service variables
ecs_service_name = "test-service-name"
docker_container_port = 8080
desired_task_number = "2"
memory = 1024