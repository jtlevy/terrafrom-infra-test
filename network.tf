resource "digitalocean_vpc" "merik" {
	name = "merik-walledgarden"

	region = var.region

	ip_range = "10.10.0.0/24"
}