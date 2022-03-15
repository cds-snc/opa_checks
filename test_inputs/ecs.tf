data "aws_iam_policy_document" "ecs-service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs-service" {
  name = "ecs-role"
  assume_role_policy = data.aws_iam_policy_document.ecs-service.json
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-cluster"
}

data "template_file" "ecs-service" {
  template = file("./ecs.json.tpl")

  vars = {
    image                 = "fooBar"
  }
}

resource "aws_ecs_task_definition" "ecs-service" {
  family                   = "ecs-cluster"
  execution_role_arn       = aws_iam_role.ecs-service.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = data.template_file.ecs-service.rendered
}

resource "aws_ecs_service" "main" {
  name             = "ecs-service-service"
  cluster          = aws_ecs_cluster.ecs-cluster.id
  task_definition  = aws_ecs_task_definition.ecs-service.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  propagate_tags   = "SERVICE"

  network_configuration {
      subnets = []
    assign_public_ip = false
  }
}