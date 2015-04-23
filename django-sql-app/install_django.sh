#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update

# install Python
sudo apt-get -y install python-setuptools

# install DJango
sudo easy_install django

sudo apt-get -y install freetds-dev freetds-bin
sudo apt-get -y install python-dev python-pip
sudo pip install pymssql

# install Apache
sudo apt-get -y install apache2 libapache2-mod-wsgi

# create a django app
cd /var/www
sudo django-admin startproject helloworld

echo """from django.http import HttpResponse
from django.shortcuts import render
from django.http import HttpRequest
from django.template import RequestContext
from datetime import datetime
import pymssql
      
def contact(request):
    assert isinstance(request, HttpRequest)
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)
def about(request):
    assert isinstance(request, HttpRequest)
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)
def home2(request):
    assert isinstance(request, HttpRequest)
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)
def home(request):
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)""" | sudo tee /var/www/helloworld/helloworld/views.py



echo """from django.conf.urls import patterns, url
from datetime import datetime
urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'helloworld.views.home', name='home'),
    url(r'^home2', 'helloworld.views.home2', name='home2'),
    url(r'^home', 'helloworld.views.home', name='home'),
    url(r'^contact$', 'helloworld.views.contact', name='contact'),
    url(r'^about', 'helloworld.views.about', name='about'),
)""" | sudo tee /var/www/helloworld/helloworld/urls.py

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