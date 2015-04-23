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

# create a django app
cd /var/www
sudo django-admin startproject helloworld

# Create a new file named views.py in the /var/www/helloworld/helloworld directory. This will contain the view
# that renders the "hello world" page
echo """from django.http import HttpResponse
from django.shortcuts import render
from django.http import HttpRequest
from django.template import RequestContext
from datetime import datetime
import pymssql
def home2(request):
    conn = pymssql.connect(server='fejcz4m54q.database.windows.net',user='meet_bhagdev@fejcz4m54q', password='*********', database='meet_bhagdev')
    cursor = conn.cursor()
    query = str("""UPDATE votes SET value = value + 1 WHERE name = '""")+ str(request.POST['group1']) + str("""' """)
    print query
    cursor.execute(query)
    conn.commit()
    cursor.execute('SELECT * FROM votes')
    result = ""
    row = cursor.fetchone()
    while row:
        result += str(row[0]) + str(" : ") + str(row[1]) + str(" votes")
        result += str("\n")
        row = cursor.fetchone()
    print result
    print request.POST['group1']
      
def contact(request):
    assert isinstance(request, HttpRequest)
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)

def about(request):
    assert isinstance(request, HttpRequest)
   	html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)

def home(request):
    html = "<html><body>Hello World!</body><html>"
    return HttpResponse(html)""" | sudo tee /var/www/helloworld/helloworld/views.py



echo "from django.conf.urls import patterns, url
from datetime import datetime
urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'votes.views.home', name='home'),
    url(r'^home2', 'votes.views.home2', name='home2'),
    url(r'^home', 'votes.views.home', name='home'),

    url(r'^contact$', 'votes.views.contact', name='contact'),
    url(r'^about', 'votes.views.about', name='about'),
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
