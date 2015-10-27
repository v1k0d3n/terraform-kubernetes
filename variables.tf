#
# Welcome to the Terraform Kubernetes Lab provided by v1k0d3n.
# http://github.com/v1k0d3n/tform-ostack-kubelab
# 2015-10-26
# Feel free to use and update as you wish, but please give
# give back to the open-source community and credit the
# folks who have helped you learn new things along the way!
# Brandon B. Jozsa
#
# This is the variables file:
# THIS IS THE ONLY FILE YOU SHOULD NEED TO EDIT
# Follow the instructions. I have included a terraform plan to help
# place some normacy around the variables given below.
#
/* The Terraform Provider */
variable "kubemaster_image" {
    default = "Vendor: Fedora Base (Cloud 22)"
}

variable "kubenode_image" {
    default = "Atomic Centos (Generic Cloud 7) 20151001"
}

variable "kubemaster_flavor" {
    default = "J2.MAC.4G.40XG"
}

variable "kubenode_flavor" {
    default = "J1.SML.2G.40XG"
}

variable "ssh_key_file" {
    default = "~/.ssh/terraform"
}

variable "ssh_key_file_pub" {
    default = "~/.ssh/terraform.pub"
}
variable "ssh_key_hash" {
    default = "REPLACE-WITH-PUB-KEY-HASH=user@email.com"
}
variable "kubemaster_ssh_user_name" {
    default = "fedora"
}

variable "kubenode_ssh_user_name" {
    default = "centos"
}

variable "cidr" {
    default = "10.8.80.0/24"
}

variable "dns" {
    default = "8.8.8.8,8.8.4.4"
}

variable "kubemaster_fixed_ipv4" {
    default = "10.8.80.10"
}

variable "kubenode01_fixed_ipv4" {
    default = "10.8.80.11"
}

variable "kubenode02_fixed_ipv4" {
    default = "10.8.80.12"
}

variable "kubenode03_fixed_ipv4" {
    default = "10.8.80.13"
}

variable "kubenode04_fixed_ipv4" {
    default = "10.8.80.14"
}

variable "kubenode05_fixed_ipv4" {
    default = "10.8.80.15"
}

variable "pub_pool" {
    default = "jinkit_net"
}

variable "pri_pool" {
    default = "net_70"
}

variable "external_gateway" {
    default = "ID-OF-OPENSTACK-EXTERNAL-GATEWAY"
}

variable "internal_gateway" {
    default = "ID-OF-OPENSTACK-INTERNAL-GATEWAY"
}

variable "root_password" {
    default = "changeme"
}

variable "cloud_config" {
    default = "kubenode/cloud-config.yaml"
}
