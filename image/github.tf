resource "github_repository_webhook" "main" {
  active = true
  events = ["release"]
  repository = "${data.github_repository.main.name}"

  configuration {
    url          = "${aws_codebuild_webhook.main.payload_url}"
    secret       = "${aws_codebuild_webhook.main.secret}"
    content_type = "json"
    insecure_ssl = false
  }
}

resource "aws_codebuild_webhook" "main" {
  project_name  = "${aws_codebuild_project.main.name}"
  branch_filter = "master"
}