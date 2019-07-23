module "crucial-sandbox" {
  source            = "../modules/aws-rancher-cluster"
  name              = "crucial-sandbox"
  vpc_id            = "${data.terraform_remote_state.main.vpc_id}"
  public_subnet_ids = "${data.terraform_remote_state.main.public_subnet_ids}"
  private_subnet_ids = "${data.terraform_remote_state.main.private_subnet_ids}"
  instance_type = "t2.medium"
  worker_num = "2"
}
