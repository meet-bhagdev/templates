PASSWORD="1234qwerASDF"

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server.list | sudo tee /etc/apt/sources.list.d/mssql-server.list

apt-get update
apt-get install -y mssql-server

SA_PASSWORD=$PASSWORD /opt/mssql/bin/mssql-conf setup accept-eula
