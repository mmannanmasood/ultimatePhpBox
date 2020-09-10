# @Author Muhammad Mannan
#!/usr/bin/env bash

echo "#############################"
echo "#### CREATING SWAP SPACE ####"
echo "#############################"
dd if=/dev/zero of=/swapfile bs=512M count=8
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "" >> /etc/fstab
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab

echo "##############################"
echo "#### CREATING DIRECTORIES ####"
echo "##############################"
mkdir -p /var/www/php56.com
mkdir -p /var/www/php70.com
mkdir -p /var/www/php71.com
mkdir -p /var/www/php72.com
mkdir -p /var/www/php73.com
mkdir -p /var/www/php74.com

# update
echo "########################"
echo "##### UPDATING APT #####"
echo "########################"
apt-get update

# Install Apache
echo "#############################"
echo "##### INSTALLING APACHE #####"
echo "#############################"
apt-get -y install apache2

echo "###############################"
echo "##### INSTALLING RABBITMQ #####"
echo "###############################"
apt-get -y install rabbitmq-server

echo "###############################"
echo "##### CREATING RABBITMQ USER #####"
echo "###############################"
rabbitmqctl add_user admin admin123
rabbitmqctl set_user_tags admin administrator

echo "#################################"
echo "##### INSTALLING open jdk 8 #####"
echo "#################################"
apt-get -y install openjdk-8-jdk

echo "######################################"
echo "##### INSTALLING ElasticSearch 7 #####"
echo "######################################"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install -y elasticsearch

# Creating folder
echo "#######################################"
echo "##### Setting FOLDER PERMISSIONS #####"
echo "#######################################"
chmod 0777 -R /var/www/php56.com
chmod 0777 -R /var/www/php70.com
chmod 0777 -R /var/www/php71.com
chmod 0777 -R /var/www/php72.com
chmod 0777 -R /var/www/php73.com
chmod 0777 -R /var/www/php74.com

# enable modrewrite
echo "#######################################"
echo "##### ENABLING APACHE MOD-REWRITE #####"
echo "#######################################"
a2enmod rewrite

# Setting Locales
echo "###########################"
echo "##### Setting Locales #####"
echo "###########################"
locale-gen en_US en_US.UTF-8 pl_PL pl_PL.UTF-8
# Piping output to file to avoid breaking shell through bad escape characters.
dpkg-reconfigure locales > /tmp/ignoreme

# Install MySQL 5.6
echo "############################"
echo "##### INSTALLING MYSQL #####"
echo "############################"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install software-properties-common
apt-get -q -y install mysql-server mysql-client

# Create Database instance
echo "#############################"
echo "##### CREATING DATABASE #####"
echo "#############################"
mysql -u root -e "create database magento;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"

echo "##############################"
echo "##### INSTALLING PHP #####"
echo "##############################"
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get -y update
apt-get -y install php5.6 php5.6-fpm php7.0 php7.0-fpm php7.1 php7.1-fpm php7.2 php7.2-fpm php7.3 php7.3-fpm php7.4 php7.4-fpm libapache2-mod-fcgid

# Install Required PHP extensions
echo "#####################################"
echo "##### INSTALLING PHP EXTENSIONS #####"
echo "#####################################"
apt-get -y install php5.6-mcrypt php5.6-curl php5.6-bcmath php5.6-soap php5.6-cli php5.6-mysql php5.6-gd php5.6-intl php5.6-common php5.6-dev php5.6-xsl php5.6-xml php5.6-mbstring php5.6-zip php5.6-xdebug libapache2-mod-php5.6
apt-get -y install php7.0-mcrypt php7.0-curl php7.0-bcmath php7.0-soap php7.0-cli php7.0-mysql php7.0-gd php7.0-intl php7.0-common php7.0-dev php7.0-xsl php7.0-xml php7.0-mbstring php7.0-zip php7.0-xdebug libapache2-mod-php7.0
apt-get -y install php7.1-mcrypt php7.1-curl php7.1-bcmath php7.1-soap php7.1-cli php7.1-mysql php7.1-gd php7.1-intl php7.1-common php7.1-dev php7.1-xsl php7.1-xml php7.1-mbstring php7.1-zip php7.1-xdebug libapache2-mod-php7.1
apt-get -y install php7.2-curl php7.2-bcmath php7.2-soap php7.2-cli php7.2-mysql php7.2-gd php7.2-intl php7.2-common php7.2-dev php7.2-xsl php7.2-xml php7.2-mbstring php7.2-zip php7.2-xdebug libapache2-mod-php7.2
apt-get -y install php7.3-curl php7.3-bcmath php7.3-soap php7.3-cli php7.3-mysql php7.3-gd php7.3-intl php7.3-common php7.3-dev php7.3-xsl php7.3-xml php7.3-mbstring php7.3-zip php7.3-xdebug libapache2-mod-php7.3
apt-get -y install php7.4-curl php7.4-bcmath php7.4-soap php7.4-cli php7.4-mysql php7.4-gd php7.4-intl php7.4-common php7.4-dev php7.4-xsl php7.4-xml php7.4-mbstring php7.4-zip php7.4-xdebug libapache2-mod-php7.4

systemctl start php5.6-fpm
systemctl start php7.0-fpm
systemctl start php7.1-fpm
systemctl start php7.2-fpm
systemctl start php7.3-fpm
systemctl start php7.4-fpm

a2enmod actions fcgid alias proxy_fcgi

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP5.6 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php56.com
     ServerName php56.com
     DocumentRoot /var/www/php56.com
     DirectoryIndex index.php

     <Directory /var/www/php56.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php5.6-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php56.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php56.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php56.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php56.com" >> /etc/hosts

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP7.0 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php70.com
     ServerName php70.com
     DocumentRoot /var/www/php70.com
     DirectoryIndex index.php

     <Directory /var/www/php70.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php7.0-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php70.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php70.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php70.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php70.com" >> /etc/hosts

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP7.1 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php71.com
     ServerName php71.com
     DocumentRoot /var/www/php71.com
     DirectoryIndex index.php

     <Directory /var/www/php71.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php7.1-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php71.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php71.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php71.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php71.com" >> /etc/hosts

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP7.2 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php72.com
     ServerName php72.com
     DocumentRoot /var/www/php72.com
     DirectoryIndex index.php

     <Directory /var/www/php72.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php7.2-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php72.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php72.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php72.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php72.com" >> /etc/hosts

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP7.3 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php73.com
     ServerName php73.com
     DocumentRoot /var/www/php73.com
     DirectoryIndex index.php

     <Directory /var/www/php73.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php7.3-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php73.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php73.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php73.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php73.com" >> /etc/hosts

echo "##################################################"
echo "##### CREATING APACHE CONFIG FILE FOR PHP7.4 #####"
echo "##################################################"
echo "
<VirtualHost *:80>
     ServerAdmin admin@php74.com
     ServerName php74.com
     DocumentRoot /var/www/php74.com
     DirectoryIndex index.php

     <Directory /var/www/php74.com>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
      # For Apache version 2.4.10 and above, use SetHandler to run PHP as a fastCGI process server
      SetHandler 'proxy:unix:/run/php/php7.4-fpm.sock|fcgi://localhost'
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/php74.com_error.log
     CustomLog ${APACHE_LOG_DIR}/php74.com_access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/php74.conf
echo "" >> /etc/hosts
echo "" >> /etc/hosts
echo "127.0.0.1 php74.com" >> /etc/hosts


# Enabling Site
echo "##################################"
echo "##### Enabling Php Sites #####"
echo "##################################"
a2ensite php56.conf
a2ensite php70.conf
a2ensite php71.conf
a2ensite php72.conf
a2ensite php73.conf
a2ensite php74.conf
a2dissite 000-default.conf

# Restart apache
echo "#############################"
echo "##### RESTARTING APACHE #####"
echo "#############################"
service apache2 restart


# Set PHP Timezone
echo "########################"
echo "##### PHP TIMEZONE #####"
echo "########################"
echo "date.timezone = America/New_York" >> /etc/php/5.6/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php/7.0/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php/7.1/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php/7.2/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php/7.3/cli/php.ini
echo "date.timezone = America/New_York" >> /etc/php/7.4/cli/php.ini

# Install Pecl Config variables
echo "############################"
echo "##### CONFIGURE XDEBUG #####"
echo "############################"
echo "xdebug.remote_enable = 1" >> /etc/php/5.6/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/apache2/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.0/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.0/apache2/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.1/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.1/apache2/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.2/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/apache2/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.3/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.3/apache2/php.ini

echo "xdebug.remote_enable = 1" >> /etc/php/7.4/apache2/php.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.4/apache2/php.ini

# Install Git
echo "##########################"
echo "##### INSTALLING GIT #####"
echo "##########################"
apt-get -y install git


echo "###############################"
echo "##### INSTALLING COMPOSER #####"
echo "###############################"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Set Ownership and Permissions
echo "#############################################"
echo "##### SETTING OWNERSHIP AND PERMISSIONS #####"
echo "#############################################"
chown -R www-data:www-data /var/www/php56.com/
chown -R www-data:www-data /var/www/php70.com/
chown -R www-data:www-data /var/www/php70.com/
chown -R www-data:www-data /var/www/php72.com/
chown -R www-data:www-data /var/www/php73.com/
chown -R www-data:www-data /var/www/php74.com/
# Add vagrant user to www-data group
usermod -a -G www-data vagrant

echo "##################################"
echo "##### Installing n98-magerun #####"
echo "##################################"
cd /tmp
wget https://files.magerun.net/n98-magerun2.phar
chmod +x ./n98-magerun2.phar
sudo mv ./n98-magerun2.phar /usr/local/bin/magerun

echo "#################################"
echo "##### Installing PHPMyAdmin #####"
echo "#################################"
# PHPMyAdmin
export DEBIAN_FRONTEND=noninteractive
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/app-password-confirm password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/mysql/app-pass password root' | debconf-set-selections > /tmp/ignoreme
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections > /tmp/ignoreme
apt-get install -y  php-gettext phpmyadmin > /tmp/ignoreme

sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php

echo "######################################"
echo "###### Setting Up ElasticSearch ######"
echo "######################################"
sed -i "s/#network.host: .*/network.host: 0.0.0.0/" /etc/elasticsearch/elasticsearch.yml
sed -i "s/#http.port: .*/http.port: 9200/" /etc/elasticsearch/elasticsearch.yml
echo 'discovery.type: single-node' >> /etc/elasticsearch/elasticsearch.yml
sed -i "s|#JAVA_HOME.*|JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre|" /etc/default/elasticsearch

sed -i "s/#START_DAEMON=true.*/START_DAEMON=true/" /etc/default/elasticsearch
sed -i "s/#ES_USER=elasticsearch.*/ES_USER=elasticsearch/" /etc/default/elasticsearch
sed -i "s/#ES_GROUP=elasticsearch.*/ES_GROUP=elasticsearch/" /etc/default/elasticsearch
sed -i "s|#LOG_DIR=/var/log/elasticsearch.*|LOG_DIR=/var/log/elasticsearch|" /etc/default/elasticsearch
sed -i "s|#DATA_DIR=/var/lib/elasticsearch.*|DATA_DIR=/var/lib/elasticsearch|" /etc/default/elasticsearch
sed -i "s|#WORK_DIR=/tmp/elasticsearch.*|WORK_DIR=/tmp/elasticsearch|" /etc/default/elasticsearch
sed -i "s|#CONF_DIR=/etc/elasticsearch.*|CONF_DIR=/etc/elasticsearch|" /etc/default/elasticsearch
sed -i "s|#CONF_FILE=/etc/elasticsearch/elasticsearch.yml.*|CONF_FILE=/etc/elasticsearch/elasticsearch.yml|" /etc/default/elasticsearch
sed -i "s|#RESTART_ON_UPGRADE=true.*|RESTART_ON_UPGRADE=true|" /etc/default/elasticsearch
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl start elasticsearch.service


# Restart apache
echo "#############################"
echo "##### RESTARTING APACHE #####"
echo "#############################"
service apache2 restart

echo "###################################"
echo "#### CONFIGURING WWW-DATA USER ####"
echo "###################################"
echo 'www-data:www-data' | chpasswd
usermod -s /bin/bash www-data
sudo cp /vagrant/vagrant/sshd_config /etc/ssh/sshd_config
service ssh restart


echo "###################################################"
echo "############ SETTING MYSQL CONFIGS ################"
echo "###################################################"
echo " "  > /etc/mysql/my.cnf
echo " "  > /etc/mysql/my.cnf
echo "
[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]
collation-server = utf8_unicode_ci
character-set-server = utf8
default_authentication_plugin = mysql_native_password
" > /etc/mysql/my.cnf


apt-get -y upgrade && apt-get -y clean autoclean && apt-get -y autoremove