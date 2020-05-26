# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    script.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sohechai <sohechai@student.le-101.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/04/21 20:00:39 by sohechai          #+#    #+#              #
#    Updated: 2020/04/26 21:57:35 by sohechai         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

# apt-get update
# apt-get upgrade -y
# apt-get install nginx -y
# apt-get install mariadb-server
# apt-get install php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cli php-cgi
# apt-get install -y php-mysql php-fpm
# apt-get install -y libnss3-tools
# apt-get install -y wget
# apt-get clean

# rm /etc/nginx/sites-available/default
# rm /etc/nginx/sites-enabled/default

service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

mkdir /var/www/localhost

mv ./tmp/nginx-on.conf /etc/nginx/sites-available/default
cp /tmp/nginx-off.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx-on.conf /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-enabled/default

cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/localhost
mv /tmp/wp-config.php /var/www/localhost/wordpress/wp-config-sample.php

mkdir /var/www/localhost/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/localhost/phpmyadmin
mv /tmp/config.inc.php /var/www/localhost/phpmyadmin/config.inc.php

mkdir ~/mkcert && \
  cd ~/mkcert && \
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
  mv mkcert-v1.1.2-linux-amd64 mkcert && \
  chmod +x mkcert
./mkcert -install
./mkcert localhost

chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*
# chmod +x ./script.sh

service mysql restart
/etc/init.d/php7.3-fpm start
service nginx restart
bash