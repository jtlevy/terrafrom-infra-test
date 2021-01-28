resource "digitalocean_firewall" "merik_secure_network" {
	name = "merik-secure-network"

	droplet_ids = [digitalocean_droplet.merik-sds.id, digitalocean_droplet.merik-fe.id, digitalocean_droplet.merik-cms.id]

	outbound_rule {
		protocol         = "tcp"
		port_range       = "80"
		destination_addresses = [digitalocean_droplet.merik-fe.ipv4_address_private]
	}

	outbound_rule {
		protocol         = "tcp"
		port_range       = "443"
		destination_addresses = [digitalocean_droplet.merik-fe.ipv4_address_private]
	}
}

resource "digitalocean_firewall" "vpn-only-access" {
	name = "vpn-only-access"
	
	droplet_ids = [digitalocean_droplet.merik-bastion.id]
	
	inbound_rule {
		protocol = "tcp"
		port_range = "22"
		source_addresses = ["159.89.140.157"]
	}
}