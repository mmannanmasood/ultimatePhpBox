# ultimatePhpBox
Vagrant Box with all php versions and phpmyadmin for mysql.

> Installed Packages
- Apache2
- MySQL 5.7
- Php-fpm 5.6, 7.0, 7.1, 7.2, 7.3, 7.4 with curl, bcmath, soap, cli, mysql, gd, intl, common, dev, xsl, xml, mbstring, zip, xdebug, libapache2-mod extensions.
- RabbitMQ server
- openjdk-8-jdk
- ElasticSearch 7
- Git
- Phpmyadmin


## Prerequisites
> Softwares Required:
- [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

> Vagrant Plugin Disksize install
- After installing vagrant and virtual box open terminal and run this command `vagrant plugin install vagrant-disksize`.

> Setup
- After all the things above mentioned are done, clone this repo, open you terminal and navigate to the folder where its clonned and run vagrant up command. Now continue your work cause it will take quiet time to complete the setup.

> Adding Vhosts to your host OS:
- Open your host machine vhost file and add these line at the end and save it.

```
# PHP 7.4
192.168.33.16  php74.com

# PHP 7.3
192.168.33.16  php73.com

# PHP 7.2
192.168.33.16  php72.com

# PHP 7.1
192.168.33.16  php71.com

# PHP 7.0
192.168.33.16  php70.com

# PHP 5.6
192.168.33.16  php56.com
```

> Change php version on CLI
- Use this command below with vagrant user and replace the x.x with the php version you want to switch on cli.
```
sudo update-alternatives --set php /usr/bin/phpx.x
```
