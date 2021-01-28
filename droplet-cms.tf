resource "digitalocean_droplet" "merik-cms" {
	image = var.cms_image

	region = var.region

	name = "merik-cms"

	size = var.cms_droplet_size

	ssh_keys = [data.digitalocean_ssh_key.main.id]

	vpc_uuid = digitalocean_vpc.merik.id

	user_data = <<EOF
		#cloud-config
		# /var/log/cloud-init-output.log - cloud init logs (this script)

		# /etc/apache2/sites-available
		# /var/www/html
		# sudo systemctl restart apache

		# how to copy files off server
		# scp dave@hoverflytest39.westeurope.cloudapp.azure.com:/home/dave/php.ini .

		# https://www.journaldev.com/24954/install-wordpress-on-ubuntu  (suggests Maria)
		# https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-ubuntu-18-04
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

		# PHP - this installs 74
		- sudo apt install php7.4 libapache2-mod-php php-mysql -y
		- sudo apt install php-curl php-gd php-mbstring php-xml php-xmlrpc php-intl php-zip -y
		- sudo apt install imagemagick -y
		- sudo apt install php-imagick -y

		# checks for syntax errors in apache conf
		- sudo apache2ctl configtest
		- sudo systemctl restart apache2

		# Wordpress CLI
		# https://www.linode.com/docs/websites/cms/wordpress/install-wordpress-using-wp-cli-on-ubuntu-18-04/
		- cd ~ 
		- sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		- sudo chmod +x wp-cli.phar
		- sudo mv wp-cli.phar /usr/local/bin/wp

		- cd /var/www/
		- sudo chown -R www-data:www-data html
		- cd html
		- sudo -u www-data wp core download
		- sudo -u www-data wp core config --dbname='wordpress' --dbuser='wp_user' --dbpass='password' --dbhost='localhost' --dbprefix='wp_'

		- sudo chmod -R 755 /var/www/html/wp-content

		# I need the domain name eg http://hoverflytest427.westeurope.cloudapp.azure.com/
		# - sudo chmod 777 /home/dave/source/infra/wpcoreinstall.sh
		# - sudo -u www-data /home/dave/source/infra/wpcoreinstall.sh
		#- sudo -u www-data wp core install --url='https://hoverflylagoons.co.uk' --title='Blog Title' --admin_user='dave' --admin_password='letmein' --admin_email='email@domain.com'

		# plugins
		#- sudo -u www-data wp plugin install all-in-one-wp-migration --activate  

		# wp mail smtp (I'll bring this in through the restore so don't need to do here)
		#- sudo -u www-data wp plugin install wp-mail-smtp --activate

		# maybe don't need to restart?
		- sudo systemctl restart apache2

		final_message: "The system is finally up, after $UPTIME seconds"

		#
		# Bashtop
		#
		# - echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
		# - sudo wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
		# - sudo apt update -y
		# - sudo apt install bashtop -y

		# make a quick test page to signify that the server is ready to go
		# - cd /var/www/cookie-dave-web
		# - echo "Healthy" > healthcheck.html

		# OS updates need a reboot?
		# - sudo reboot now
	EOF

	private_networking = true

	lifecycle {
		create_before_destroy = true // dont destroy server before the new one is running!
	}
}