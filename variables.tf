variable "do_token" {}

variable "region" {
	type = string
	default = "sfo3"
}

# Front-End
variable "fe_image" {
	type = string
	default = "ubuntu-20-10-x64"
}
variable "fe_droplet_size" {
	type = string
	default = "s-1vcpu-1gb"
}

# Bastion
variable "bastion_image" {
	type = string
	default = "ubuntu-20-10-x64"
}
variable "bastion_droplet_size" {
	type = string
	default = "s-1vcpu-1gb"
}

# CMS
variable "cms_image" {
	type = string
	default = "ubuntu-20-10-x64"
}
variable "cms_droplet_size" {
	type = string
	default = "g-2vcpu-8gb"
}

# SDS
variable "sds_image" {
	type = string
	default = "ubuntu-20-10-x64"
}
variable "sds_droplet_size" {
	type = string
	default = "g-2vcpu-8gb"
}

variable "ssh_key" {
	type = string
	default = "dokey"
}