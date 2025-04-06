# Data sources to reference existing resources
data "aws_security_group" "alb_sg" {
  name = "petclinic-alb-sg"
}

data "aws_ecs_cluster" "petclinic_cluster" {
  cluster_name = "petclinic-${var.environment}-cluster" 
}

data "aws_lb" "petclinic_alb" {
  name = "petclinic-alb-${var.environment}"
}

data "aws_lb_target_group" "petclinic_tg" {
  name = "petclinic-${var.environment}-tg"
}

data "aws_cloudwatch_log_group" "petclinic_log_group" {
  name = "/ecs/petclinic-${var.environment}"
}


# ECS Task Definition
resource "aws_ecs_task_definition" "petclinic_task" {
  family                   = "petclinic-task-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "2048"
  execution_role_arn       = var.labrole_arn
  task_role_arn            = var.labrole_arn

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
        "awslogs-group"         = data.aws_cloudwatch_log_group.petclinic_log_group.name
        "awslogs-region"        = "us-east-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

# ECS Service
resource "aws_ecs_service" "petclinic_service" {
  name            = "petclinic-service-${var.environment}"
  cluster         = data.aws_ecs_cluster.petclinic_cluster.id
  task_definition = aws_ecs_task_definition.petclinic_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = var.subnet_ids
    security_groups  = [data.aws_security_group.alb_sg.name]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.petclinic_tg.arn
    container_name   = "petclinic"
    container_port   = 8080
  }
}