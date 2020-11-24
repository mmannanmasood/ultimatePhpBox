# ultimatePhpBox
Vagrant Box with all php versions and phpmyadmin for mysql.

## Prerequisites
> Softwares Required:
- [Vagrant](https://www.vagrantup.com/intro/getting-started/install.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

> Vagrant Plugin Disksize install
- After installing vagrant and virtual box open terminal and run this command `vagrant plugin install vagrant-disksize`.

> Setup
- After all the things above mentioned are done, clone this repo, open you terminal and navigate to the folder where its clonned and run vagrant up command. Now continue your work cause it will take quiet time to complete the setup.

> Adding Vhosts:
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
