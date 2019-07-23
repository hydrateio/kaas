terraform {
  backend "s3" {
    bucket = "hydrate-sandbox-terraform"
    key    = "rancher.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}



resource "aws_security_group" "rancher_sg_allow_whitelist" {
  name   = "${var.prefix}-allow-whitelist"
  vpc_id = "${data.terraform_remote_state.main.vpc_id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_whitelist}"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_cloudinit_config" "rancherserver-cloudinit" {
  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancherserver\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_server.rendered}"
  }
}

resource "aws_instance" "rancherserver" {
  ami = "${data.aws_ami.ubuntu.id}"

  instance_type = "${var.type}"
  key_name      = "${var.ssh_key_name}"

  subnet_id              = "${element(data.terraform_remote_state.main.public_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  user_data              = "${data.template_cloudinit_config.rancherserver-cloudinit.rendered}"

  tags {
    Name = "${var.prefix}-rancherserver"
  }
  lifecycle {
    ignore_changes = [ "ami" ]
  }
}

data "template_cloudinit_config" "rancheragent-all-cloudinit" {
  count = "${var.count_agent_all_nodes}"

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancheragent-${count.index}-all\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_agent.rendered}"
  }
}

resource "aws_instance" "rancheragent-all" {
  count                  = "${var.count_agent_all_nodes}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.type}"
  key_name               = "${var.ssh_key_name}"
  subnet_id              = "${element(data.terraform_remote_state.main.public_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  user_data              = "${data.template_cloudinit_config.rancheragent-all-cloudinit.*.rendered[count.index]}"

  tags {
    Name = "${var.prefix}-rancheragent-${count.index}-all"
  }

  lifecycle {
    ignore_changes = [ "ami" ]
  }
}

data "template_cloudinit_config" "rancheragent-etcd-cloudinit" {
  count = "${var.count_agent_etcd_nodes}"

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancheragent-${count.index}-etcd\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_agent.rendered}"
  }
}

resource "aws_instance" "rancheragent-etcd" {
  count                  = "${var.count_agent_etcd_nodes}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.type}"
  key_name               = "${var.ssh_key_name}"
  subnet_id              = "${element(data.terraform_remote_state.main.private_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  user_data              = "${data.template_cloudinit_config.rancheragent-etcd-cloudinit.*.rendered[count.index]}"

  tags {
    Name = "${var.prefix}-rancheragent-${count.index}-etcd"
  }

  lifecycle {
    ignore_changes = [ "ami" ]
  }
}

data "template_cloudinit_config" "rancheragent-controlplane-cloudinit" {
  count = "${var.count_agent_controlplane_nodes}"

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancheragent-${count.index}-controlplane\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_agent.rendered}"
  }
}

resource "aws_instance" "rancheragent-controlplane" {
  count                  = "${var.count_agent_controlplane_nodes}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.type}"
  key_name               = "${var.ssh_key_name}"
  subnet_id              = "${element(data.terraform_remote_state.main.private_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  user_data              = "${data.template_cloudinit_config.rancheragent-controlplane-cloudinit.*.rendered[count.index]}"

  tags {
    Name = "${var.prefix}-rancheragent-${count.index}-controlplane"
  }

  lifecycle {
    ignore_changes = [ "ami" ]
  }
}

data "template_cloudinit_config" "rancheragent-worker-cloudinit" {
  count = "${var.count_agent_worker_nodes}"

  part {
    content_type = "text/cloud-config"
    content      = "hostname: ${var.prefix}-rancheragent-${count.index}-worker\nmanage_etc_hosts: true"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.userdata_agent.rendered}"
  }
}

resource "aws_instance" "rancheragent-worker" {
  count                  = "${var.count_agent_worker_nodes}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.type}"
  key_name               = "${var.ssh_key_name}"
  subnet_id              = "${element(data.terraform_remote_state.main.public_subnet_ids, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  user_data              = "${data.template_cloudinit_config.rancheragent-worker-cloudinit.*.rendered[count.index]}"

  tags {
    Name = "${var.prefix}-rancheragent-${count.index}-worker"
  }
  lifecycle {
    ignore_changes = [ "ami" ]
  }
}

data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"

  vars {
    admin_password        = "${data.sops_file.secrets.data.admin_password}"
    cluster_name          = "${var.cluster_name}"
    docker_version_server = "${var.docker_version_server}"
    rancher_version       = "${var.rancher_version}"
  }
}

data "template_file" "userdata_agent" {
  template = "${file("files/userdata_agent")}"

  vars {
    admin_password       = "${data.sops_file.secrets.data.admin_password}"
    cluster_name         = "${var.cluster_name}"
    docker_version_agent = "${var.docker_version_agent}"
    rancher_version      = "${var.rancher_version}"
    server_address       = "${aws_instance.rancherserver.public_ip}"
  }
}



provider "rancher2" {
  api_url  = "https://rancher.${data.terraform_remote_state.main.public_dns_domain}/"
#  api_url  = "https://rancher.k8s.com/"
  insecure = true
  bootstrap = true
}

# Create a new rancher2 Bootstrap
resource "rancher2_bootstrap" "admin" {
  current_password = "${data.sops_file.secrets.data.admin_password}"
  password = "${data.sops_file.secrets.data.admin_password}"
}
