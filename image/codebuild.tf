resource "aws_codebuild_project" "main" {
  name          = "${var.name}"
  description   = "Builds the kubernetes appliance image for the k8s environment."
  build_timeout = "10"
  service_role  = "${aws_iam_role.this.arn}"

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "${data.terraform_remote_state.main.region}"
    }
    
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "${data.terraform_remote_state.main.aws_caller_identity_id}"
    }

    environment_variable {
      name  = "GITHUB_TOKEN"
      value = "${data.external.github.result["token"]}"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  artifacts = {
    type           = "NO_ARTIFACTS"
  }

  source {
    type                = "GITHUB"
    report_build_status = "true"
    location            = "${data.github_repository.main.http_clone_url}"
    buildspec           = "buildspec.yml"

    auth {
      type = "OAUTH"
    }
  }
}
