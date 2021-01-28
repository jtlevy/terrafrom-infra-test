resource "digitalocean_project" "merik" {
	name        = "Merik SF Covid Clinic"
	description = "Our mission is to vaccinate individuals from underrepresented communities at a rate of 1000 per week."
	purpose     = "Web Application"
	environment = "Development"

	resources   = [digitalocean_droplet.merik-bastion.urn,digitalocean_droplet.merik-fe.urn,digitalocean_droplet.merik-cms.urn,digitalocean_droplet.merik-sds.urn,]
}