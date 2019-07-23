resource "aws_codebuild_project" "atlantis" {
  name          = "atlantis"
  description   = "Builds the atlantis image for the k8s environment."
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
      value = "${data.sops_file.secrets.data.github_user_token}"
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = "${aws_ecr_repository.atlantis.name}"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  artifacts = {
    type           = "S3"
    location       = "${aws_s3_bucket.build.bucket}"
    name           = "atlantis"
    namespace_type = "NONE"
    packaging      = "ZIP"
  }

  source {
    type                = "GITHUB"
    report_build_status = "true"
    location            = "${data.github_repository.atlantis.http_clone_url}"
    buildspec           = "buildspec.yml"

    auth {
      type = "OAUTH"
    }
  }
}
