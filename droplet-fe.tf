resource "digitalocean_droplet" "merik-fe" {
	image = var.fe_image

	region = var.region

	name = "merik-fe"

	size = var.fe_droplet_size

	ssh_keys = [data.digitalocean_ssh_key.main.id]

	vpc_uuid = digitalocean_vpc.merik.id

	# user_data = data.template_file.cloud-init-yaml.rendered

	private_networking = true

	user_data = <<EOF
    #cloud-config
    packages:
        - nginx
    runcmd:
        - mkdir ~/terraWorked
    EOF

	lifecycle {
		create_before_destroy = true // dont destroy server before the new one is running!
	}
}