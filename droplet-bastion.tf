resource "digitalocean_droplet" "merik-bastion" {
	image = var.bastion_image

	region = var.region

	name = "merik-bastion"

	size = var.bastion_droplet_size

	ssh_keys = [data.digitalocean_ssh_key.main.id]

	vpc_uuid = digitalocean_vpc.merik.id

	private_networking = true

	lifecycle {
		create_before_destroy = true // dont destroy server before the new one is running!
	}
}