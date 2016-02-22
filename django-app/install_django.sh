#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get -y update

# install Python
apt-get -y install python-setuptools

# install DJango
easy_install django

# install Apache
apt-get -y install apache2 libapache2-mod-wsgi

wget https://github.com/meet-bhagdev/Django/archive/master.zip
unzip master.zip -d master
cd master
echo 'password' | sudo -S cp -r Django-master /var/www
# create a django app
cd /var/www


cd Django-master
python manage.py migrate
cd ..

# Setup Apache
echo "<VirtualHost *:80>
ServerName $1
</VirtualHost>
WSGIScriptAlias / /var/www/Django-master/DjangoWebProject1/wsgi.py
WSGIPythonPath /var/www/Django-master" | tee /etc/apache2/sites-available/helloworld.conf

#enable site
a2ensite helloworld

#restart apache
service apache2 reload
