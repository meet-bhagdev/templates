#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update
sudo pip install pymssql
# install Python
sudo apt-get -y install python-setuptools
sudo apt-get -y update  
sudo apt-get -y install freetds-dev freetds-bin
sudo apt-get -y install python-dev python-pip
sudo pip install pymssql

# install DJango
sudo easy_install django

# install Apache
sudo apt-get -y install apache2 libapache2-mod-wsgi





cd /var/www
sudo django-admin startproject helloworld

# Create a new file named views.py in the /var/www/helloworld/helloworld directory. This will contain the view
# that renders the "hello world" page
echo 'from django.http import HttpResponse
def home(request):
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)' | sudo tee /var/www/helloworld/helloworld/views.py
# Update urls.py
echo "from django.conf.urls import patterns, url
urlpatterns = patterns('',
    url(r'^$', 'helloworld.views.home', name='home'),
)" | sudo tee /var/www/helloworld/helloworld/urls.py

# Setup Apache
echo "<VirtualHost *:80>
ServerName $1
</VirtualHost>
WSGIScriptAlias / /var/www/helloworld/helloworld/wsgi.py
WSGIPythonPath /var/www/helloworld" | sudo tee /etc/apache2/sites-available/helloworld.conf

#enable site
sudo a2ensite helloworld

#restart apache
sudo service apache2 reload
