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
		package_upgrade: true
		runcmd:
		# Apache
		- sudo apt update -y
		- sudo apt install apache2 -y

		- sudo a2enmod rewrite
		- sudo a2enmod ssl
		- sudo a2ensite default-ssl.conf
		- sudo service apache2 restart
		
		# PHP7.4
		- sudo apt-get update
		- sudo apt install software-properties-common -y
		- sudo add-apt-repository ppa:ondrej/php -y
		- sudo apt-get update

		# PHP - this installs 7.4
		- sudo apt install php7.4 libapache2-mod-php -y
		- sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-intl php-zip -y
		
		# checks for syntax errors in apache conf
		- sudo apache2ctl configtest
		- sudo systemctl restart apache2
	EOF

	lifecycle {
		create_before_destroy = true // dont destroy server before the new one is running!
	}
}