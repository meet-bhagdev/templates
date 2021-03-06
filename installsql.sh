curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

apt-get -y update
apt-get install -y mssql-server

SA_PASSWORD=$1 /opt/mssql/bin/mssql-conf setup accept-eula
