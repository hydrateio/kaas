variable "name" {
    default = "test"
}

variable "rancheros_version" {
    default = "1.5.2"
}

variable "instance_type" {
    default = ""
}

variable "control_num" {
    default = "1"
}

variable "worker_num" {
    default = "1"
}

variable "vpc_id" {
    default = ""
}
variable "public_subnet_ids" {
    type = "list"
    default = [""]
}

variable "private_subnet_ids" {
    type = "list"
    default = [""]
}

variable "rancher_id" {
    default = ""
}