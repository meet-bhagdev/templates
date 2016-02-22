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
echo channelV1 | sudo apt-get install unzip
unzip master.zip -d master
cd master
cp -r Django-master /var/www
# create a django app
cd /var/www
django-admin startproject helloworld

# Create a new file named views.py in the /var/www/helloworld/helloworld directory. This will contain the view
# that renders the "hello world" page
echo 'from django.http import HttpResponse
def home(request):
    html = "<html><body>Hello Worlsad!</body><html>"
    return HttpResponse(html)' | tee /var/www/helloworld/helloworld/views.py
# Update urls.py
echo "from django.conf.urls import patterns, url
urlpatterns = patterns('',
    url(r'^$', 'helloworld.views.home', name='home'),
)" | tee /var/www/helloworld/helloworld/urls.py

cd Django-master
python manage.py migrate
cd ..

# Setup Apache
echo "<VirtualHost *:80>
ServerName $1
</VirtualHost>
WSGIScriptAlias / /var/www/Django-master/DjangoWebProject1/wsgi.py
WSGIPythonPath /var/www/helloworld" | tee /etc/apache2/sites-available/helloworld.conf

#enable site
a2ensite helloworld

#restart apache
service apache2 reload
