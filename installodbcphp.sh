apt-get -y install php7.0 php-pear php7.0-dev gcc
curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-tools.list
apt-get update
ACCEPT_EULA=Y apt-get install -y msodbcsql
apt-get install -y unixodbc-dev
pecl install sqlsrv-4.1.8preview  pdo_sqlsrv-4.1.8preview
echo "extension= pdo_sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
echo "extension= sqlsrv.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
