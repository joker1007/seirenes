#/bin/bash

sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

mysql_install_db

/usr/bin/mysqld_safe &
sleep 10s

echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'admin' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

killall mysqld
sleep 10s
