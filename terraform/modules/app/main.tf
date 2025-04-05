# IAM Role for ECS Task Execution (LabRole assumed)
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "petclinic_task" {
  family                   = "petclinic-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([{
    name  = "petclinic"
    image = "${var.dockerhub_username}/petclinic:${var.image_tag}"
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

# ECS Service
resource "aws_ecs_service" "petclinic_service" {
  name            = "petclinic-service-${var.environment}"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.petclinic_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      "subnet-0bf83b18a617f4b33",
      "subnet-0e0eaedd336f971e3",
      "subnet-091765090f534e073",
      "subnet-0ce390d316b25b702",
      "subnet-013444a856452b902",
      "subnet-052e2ceaea77ebb20"
    ]
    security_groups  = ["sg-053616a87cc68ce16"]
    assign_public_ip = true
  }
}