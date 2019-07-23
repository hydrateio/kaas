resource "rancher2_cluster" "main" {
  name        = "${var.name}"
  description = "${var.name}"

  rke_config {
    network {
      plugin = "flannel"
    }
  }
}

data "aws_ami_ids" "rancher" {
  owners = ["605812595337"]

  filter {
    name   = "name"
    values = ["rancheros-v${var.rancheros_version}-hvm*"]
  }
}

resource "rancher2_node_template" "public" {
  count          = "${length(data.aws_subnet.public.*.id)}"
  name           = "public-${element(data.aws_subnet.public.*.availability_zone, count.index)}"
  description    = "public node template in ${element(data.aws_subnet.public.*.availability_zone, count.index)}"

  amazonec2_config {
    ami            = "${data.aws_ami_ids.rancher.ids[0]}"
    instance_type  = "${var.instance_type}"
    ssh_user       = "rancher"
    access_key     = "${data.external.creds.result["aws_token_id"]}"
    secret_key     = "${data.external.creds.result["aws_token"]}"
    region         = "${data.aws_region.current.name}"
    zone           = "${substr(element(data.aws_subnet.public.*.availability_zone, count.index), -1, 1)}"
    security_group = ["rancher-nodes"]
    vpc_id         = "${var.vpc_id}"
    subnet_id      = "${element(var.public_subnet_ids, count.index)}"
    iam_instance_profile = "rancher"
  }
}

# Create a new rancher2 Node Pool
resource "rancher2_node_pool" "control" {
  count            = "${length(data.aws_availability_zones.available.names)}"
  cluster_id       = "${rancher2_cluster.main.id}"
  name             = "${var.name}-control-${count.index}"
  hostname_prefix  = "${var.name}-control-${count.index}"
  node_template_id = "${element(rancher2_node_template.public.*.id, count.index)}"
  quantity         = "${var.control_num}"
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "worker" {
  count            = "${length(data.aws_availability_zones.available.names)}"
  cluster_id       = "${rancher2_cluster.main.id}"
  name             = "${var.name}-worker-${count.index}"
  hostname_prefix  = "${var.name}-worker-${count.index}"
  node_template_id = "${rancher2_node_template.public.*.id[count.index]}"
  quantity         = "${var.worker_num}"
  control_plane    = false
  etcd             = false
  worker           = true
}
