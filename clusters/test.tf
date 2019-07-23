# module "test" {
#     source = "../modules/aws-rancher-cluster"
#     name = "test"
#     vpc_id            = "${data.terraform_remote_state.main.vpc_id}"
#     public_subnet_ids = "${data.terraform_remote_state.main.public_subnet_ids}"
#     private_subnet_ids = "${data.terraform_remote_state.main.private_subnet_ids}"
# }