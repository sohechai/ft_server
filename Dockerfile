# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sohechai <sohechai@student.le-101.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/04/20 22:26:13 by sohechai          #+#    #+#              #
#    Updated: 2020/04/26 21:54:55 by sohechai         ###   ########lyon.fr    #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

LABEL maintainer="<sohechai@student.le-101.fr>"

RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx -y
RUN apt-get install mariadb-server -y
RUN apt-get install php -y
RUN apt-get install php-cli php-fpm php-cgi -y
RUN apt-get install php-mysql -y
RUN apt-get install php-mbstring -y
RUN apt-get install wget -y

# COPY ./srcs/wordpress ./tmp/
COPY ./srcs/wp-config.php ./tmp/wp-config.php
COPY ./srcs/config.inc.php ./tmp/config.inc.php
COPY ./srcs/nginx-on.conf ./tmp/
COPY ./srcs/nginx-off.conf ./tmp/
COPY ./srcs/script.sh ./

EXPOSE	80

CMD bash script.sh

# RUN apt-get update && apt-get upgrade -y
# RUN apt-get install wget -y
# RUN apt-get install nginx -y
# RUN apt-get install mariadb-server -y
# RUN apt-get install php -y
# RUN apt-get install php-cli php-fpm php-cgi -y
# RUN apt-get install php-mysql -y
# RUN apt-get install php-mbstring -y

# COPY /srcs/index.php /var/www/html/
# COPY srcs/init.sql /var/www/
# COPY srcs/script.sh .

# RUN /etc/init.d/php7.3-fpm start

# CMD bash script.sh && service nginx start