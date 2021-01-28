resource "digitalocean_droplet" "merik-sds" {
	image = var.sds_image

	region = var.region

	name = "merik-sds"

	size = var.sds_droplet_size

	ssh_keys = [data.digitalocean_ssh_key.main.id]

	vpc_uuid = digitalocean_vpc.merik.id

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
		# Mysql
		- sudo apt install mysql-server -y

		# should i do this?
		- sudo mysql_secure_installation

		- sudo mysql -e "CREATE DATABASE merik_cms;"
		- sudo mysql -e "CREATE USER 'merik'@'localhost' IDENTIFIED BY 'u2k7x3n39u=N';"
		- sudo mysql -e "GRANT ALL ON wordpress.* TO 'merik'@'localhost' IDENTIFIED BY 'u2k7x3n39u=N';"
		- sudo mysql -e "FLUSH PRIVILEGES;"

		# PHP7.4
		- sudo apt-get update
		- sudo apt install software-properties-common -y
		- sudo add-apt-repository ppa:ondrej/php -y
		- sudo apt-get update

		# PHP - this installs 7.4
		- sudo apt install php7.4 libapache2-mod-php php-mysql -y
		- sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-intl php-zip -y

		# PECL

		# Libsodium
		sudo pecl install -f libsodium
		sudo echo "extension = sodium.so" > /etc/php/7.4/mods-available/sodium.ini
		sudo phpenmod sodium 
		
		# checks for syntax errors in apache conf
		- sudo apache2ctl configtest
		- sudo systemctl restart apache2
	EOF

	private_networking = true

	lifecycle {
		create_before_destroy = true // dont destroy server before the new one is running!
	}
}