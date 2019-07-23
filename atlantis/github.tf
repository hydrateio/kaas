data "github_ip_ranges" "main" {}

resource "github_repository_webhook" "atlantis_infrastructure" {
  repository = "${var.github_terraform_repository}"
  configuration {
    url          = "${local.atlantis_url_events}"
    content_type = "json"
    insecure_ssl = false
    secret       = "${random_id.atlantis_infrastructure_webhook.hex}"
  }

  events = [
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment",
  ]

  lifecycle {
    # The secret is saved as ******* in the state
    ignore_changes = ["configuration.secret"]
  }
}

resource "aws_codebuild_webhook" "atlantis" {
  project_name  = "${aws_codebuild_project.atlantis.name}"
  branch_filter = "master"
}

data "github_repository" "atlantis" {
  full_name = "${var.github_organization}/${var.github_atlantis_repository}"
}
resource "github_repository_webhook" "atlantis" {
  active = true
  events = ["push", "pull_request"]
  repository = "${data.github_repository.atlantis.name}"

  configuration {
    url          = "${aws_codebuild_webhook.atlantis.payload_url}"
    secret       = "${aws_codebuild_webhook.atlantis.secret}"
    content_type = "json"
    insecure_ssl = false
  }
}