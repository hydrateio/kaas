# create the Admins group
resource "aws_iam_group" "admin" {
  name = "Admins"
  path = "/"
}

# stick the admins in the admin group
resource "aws_iam_group_membership" "admins" {
  name = "admin-group-membership"

  users = [
    "${aws_iam_user.steve.name}",
    "${aws_iam_user.abram.name}",
    "${aws_iam_user.ci.name}",
  ]

  group = "${aws_iam_group.admin.name}"
}

# attach the administrator access policy to the Admin group
resource "aws_iam_policy_attachment" "admin" {
  name       = "Administrator Access"
  groups     = ["${aws_iam_group.admin.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_key_pair" "steve" {
  key_name   = "steve"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCi3StqAsqwS8V1Ne5WVV21jCXf39GPHSGwssPTAbqF9FDhcHGKXCM2g3sgYEaLjFJ/tILa9VrV0Z7hkOpnipguj3PJgt36aztnpvlB+CvqtIunzBhe3XlpZmU4NuhlZwN+i1wwCbrDjQHbeOVXqju2MAReeO2A5/UkCb1EvOyi4cgFUpoaxz+bNnrOq8YRMfLldbjLs3exSN9dc/VrwwKTT/cnHKEVwtFqUWT92f5taSdV0dvvQkHxKjxSbcy7UmHYuV3dAaUE+8nXQulkcTWMpADaEuhNWZr1BU+hC+J5RcgFN+v6H5OAEfX9eDGYtlsBLSoox/f6V2k0Wz2IrlIX"
}

resource "aws_iam_user" "steve" {
  name = "steve"
}

resource "aws_key_pair" "abram" {
  key_name   = "abram"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCz83kygHgwvYdipZSLZukCejbjOLDOVmWJCFRFneRU1E50uKYhwGS3Z/z8QXmVsZjo9VbNt+3l+P3/67koCzSKI8oWDA8RafzXeuDe0flAWEP77Em7E5PE6LZBZlGIKHXIAI05YWyfjCy3+AOwy24hu07OsmFp7xB5XrKcoQTLAtN8ofB46Pn3EqdxJv6XLHfiMIeXoGWiWvs6DOeGWM6eDb3xkHGlfEDgqKo9fhVNieJTpEHZ1NvbPszi83cCg+oW+aKdvPYlCvhIiAaPgAX1ja39HhIo+j5YwLjmSpPXFH662evjCQA08gobuXafxMEKuzqdt5IcU0zCFv8LW/Dh acisola@system76-ubuntu"
}

resource "aws_iam_user" "abram" {
  name = "abram"
}

resource "aws_key_pair" "ci" {
  key_name   = "ci"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkI4gT3lvzNKqeGlqhCgtmuSQsUDxml8gpcsABLAPf3pX7v0LRMQvTpn9+YIXp6SJ+2XFQGFR0y3009JAdMfVbXN72RMlvBKaHsV9EWyyY9bFV6GGhM1K+tHAXhe5+lPopRSfqtVR8ijWk8wJqvEoZImhhzMnXsgoceD8ZDQStAw85fFw7sYvEh57/RI5qajPgxHqs8FGADiHmtp9MJ6g5jfL+ZlhUU81sjZFA5qEEUEJueAwamOU+0uPp8kUqr87pkcOWGjJPkscWgN1M3wAGCotksR7skFBxlI22IADdKVw5I60LxvCOz9nHnA0EGNqF3OVrkoBmgyHhXk2zNqa5 ci@hydrate-sandbox"
}

resource "aws_iam_user" "ci" {
  name = "ci"
}
