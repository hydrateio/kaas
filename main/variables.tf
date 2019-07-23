variable "name" {
    default = ""
}

variable "region" {
    default = ""
}
variable "vpc_cidr" {
    default = ""
}

variable "azs" {
    type = "list"
    default = []
}

variable "private_subnets" {
    default = []
    type = "list"
}

variable "public_subnets" {
    default = []
    type = "list"
}

variable "public_dns_domain" {
    default = ""
}

variable "private_dns_domain" {
    default = ""
}
variable "intra_subnets" {
    default = []
    type = "list"
}
variable "database_subnets" {
    default = []
    type = "list"
}

