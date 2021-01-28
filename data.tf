data "digitalocean_ssh_key" "main" {
	name = var.ssh_key
}

# data "local_file" "cloud-init-fe-yaml" {
# 	filename = file("/Users/joshual/Dropbox/Clients/Merik/merik-infrastructure/cloud-init-fe.yaml")
# }

# data "template_file" "cloud-init-fe-yaml" {
#   template = data.local_file.cloud-init-fe-yaml.content
# }

# data "local_file" "cloud-init-cms-yaml" {
# 	filename = file("/Users/joshual/Dropbox/Clients/Merik/merik-infrastructure/cloud-init-cms.yaml")
# }

# data "template_file" "cloud-init-cms-yaml" {
#   template = data.local_file.cloud-init-cms-yaml.content
# }

# data "local_file" "cloud-init-sds-yaml" {
# 	filename = file("/Users/joshual/Dropbox/Clients/Merik/merik-infrastructure/cloud-init-sds.yaml")
# }

# data "template_file" "cloud-init-sds-yaml" {
#   template = data.local_file.cloud-init-sds-yaml.content
# }