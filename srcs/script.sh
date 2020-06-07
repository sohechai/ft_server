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

# setup nginx
# mkdir /var/www/localhost
ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default

# setup wordpress
wget -c https://wordpress.org/latest.tar.gz
mkdir /var/www/html/wordpress
tar -xvzf latest.tar.gz --strip-components=1 -C /var/www/html/wordpress
mv /tmp/wp-config.php /var/www/html/wordpress
ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

# setup my sql
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root
echo "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'password';" | mysql -u root
echo "SET PASSWORD FOR root@localhost=PASSWORD('password');" | mysql -u root
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'admin'@'localhost';" | mysql -u root
echo "FLUSH PRIVILEGES;" | mysql -u root

# setup phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz
mkdir /var/www/html/phpmyadmin
tar xzf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin
mv /tmp/config.inc.php /var/www/html/phpmyadmin/config.sample.inc.php

#  ssl certification
mkdir ~/mkcert && \
  cd ~/mkcert && \
  wget https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 && \
  mv mkcert-v1.1.2-linux-amd64 mkcert && \
  chmod +x mkcert
./mkcert -install
./mkcert localhost

# droit
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# comeback home
cd ../..

service php7.3-fpm start
service nginx restart
bash