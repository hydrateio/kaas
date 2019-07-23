resource "aws_ecr_repository" "atlantis" {
  name = "atlantis"
}

module "atlantis_ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "v1.0.0"

  name = "atlantis"
}

resource "aws_ecs_task_definition" "atlantis" {
  family                   = "atlantis"
  execution_role_arn       = "${aws_iam_role.this.arn}"
  task_role_arn            = "${aws_iam_role.this.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024

  container_definitions = <<EOF
[
    {
        "cpu": 0,
        "environment": [
          {
            "name": "ATLANTIS_ALLOW_REPO_CONFIG",
            "value": "true"
          },
          {
              "name": "ATLANTIS_LOG_LEVEL",
              "value": "debug"
          },
          {
              "name": "ATLANTIS_PORT",
              "value": "4141"
          },
          {
              "name": "ATLANTIS_ATLANTIS_URL",
              "value": "${local.atlantis_url}"
          },
          {
              "name": "ATLANTIS_GH_USER",
              "value": "${data.sops_file.secrets.data.github_user}"
          },
          {
              "name": "ATLANTIS_GH_TOKEN",
              "value": "${data.sops_file.secrets.data.github_user_token}"
          },
          {
              "name": "ATLANTIS_GH_WEBHOOK_SECRET",
              "value": "${random_id.atlantis_infrastructure_webhook.hex}"
          },
          {
              "name": "ATLANTIS_REPO_WHITELIST",
              "value": "github.com/${var.github_organization}/${var.github_terraform_repository}"
          },
          {
              "name": "ATLANTIS_DEFAULT_TF_VERSION",
              "value": "v0.11.14"
          }

        ],
        "essential": true,
        "image": "${aws_ecr_repository.atlantis.repository_url}:latest",
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group.atlantis.name}",
                "awslogs-region": "${data.terraform_remote_state.main.region}",
                "awslogs-stream-prefix": "master"
            }
        },
        "mountPoints": [],
        "name": "atlantis",
        "portMappings": [
            {
                "containerPort": 4141,
                "hostPort": 4141,
                "protocol": "tcp"
            }
        ],
        "volumesFrom": []
    }
]
EOF
}

resource "aws_ecs_service" "atlantis" {
  name                               = "atlantis"
  cluster                            = "${module.atlantis_ecs.this_ecs_cluster_id}"
  task_definition                    = "${aws_ecs_task_definition.atlantis.family}:${aws_ecs_task_definition.atlantis.revision}"
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  network_configuration {
    subnets          = ["${data.terraform_remote_state.main.public_subnet_ids}"]
    security_groups  = ["${module.atlantis_sg.this_security_group_id}"]
    assign_public_ip = "true"
  }

  load_balancer {
    container_name   = "atlantis"
    container_port   = 4141
    target_group_arn = "${element(module.atlantis_alb.target_group_arns, 0)}"
  }
}
