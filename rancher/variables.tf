variable "prefix" {
  default     = "yourname"
  description = "Cluster Prefix - All resources created by Terraform have this prefix prepended to them"
}

variable "rancher_version" {
  default     = "latest"
  description = "Rancher Server Version"
}

variable "count_agent_all_nodes" {
  default     = "1"
  description = "Number of Agent All Designation Nodes"
}

variable "count_agent_etcd_nodes" {
  default     = "0"
  description = "Number of ETCD Nodes"
}

variable "count_agent_controlplane_nodes" {
  default     = "0"
  description = "Number of K8s Control Plane Nodes"
}

variable "count_agent_worker_nodes" {
  default     = "0"
  description = "Number of Worker Nodes"
}

variable "cluster_name" {
  default     = "quickstart"
  description = "Kubernetes Cluster Name"
}

variable "region" {
  default     = "us-west-2"
  description = "Amazon AWS Region for deployment"
}

variable "type" {
  default     = "t3.medium"
  description = "Amazon AWS Instance Type"
}

variable "docker_version_server" {
  default     = "18.09"
  description = "Docker Version to run on Rancher Server"
}

variable "docker_version_agent" {
  default     = "18.09"
  description = "Docker Version to run on Kubernetes Nodes"
}

variable "ssh_key_name" {
  default     = ""
  description = "Amazon AWS Key Pair Name"
}

variable "cidr_whitelist" {
  default = ["0.0.0.0/0"]
  type    = "list"
}

locals {
  "rancher_creds" {
    token_id     = "${rancher2_bootstrap.admin.token_id}"
    token        = "${rancher2_bootstrap.admin.token}"
    aws_token_id = "${aws_iam_access_key.rancher.id}"
    aws_token    = "${aws_iam_access_key.rancher.secret}"
  }
}
