#!/usr/bin/env bash

echo "Installing apache and setting it up !!!"
apt-get update >/dev/null 
apt-get install -y apache2  
apt-get install -y build-essential libssl-dev libffi-dev python-dev python-pip memcached
pip install pyopenssl
pip install flask
pip install python-memcached


#rm -rf /var/www
#ln -fs /vagrant /var/www
#mkdir /var/www/app
#echo "testing from app">/var/www/app/index.html #Initial testing
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/default
echo "ServerAdmin webmaster@localhost">> /etc/apache2/sites-available/default
echo "DocumentRoot /var/www/">>/etc/apache2/sites-available/default
echo "RewriteEngine On">> /etc/apache2/sites-available/default
echo "RewriteCond %{HTTPS} off">>/etc/apache2/sites-available/default
echo "RewriteRule ^ https://localhost:8443%{REQUEST_URI}">>/etc/apache2/sites-available/default
echo "ErrorLog ${APACHE_LOG_DIR}/error.log">>/etc/apache2/sites-available/default
echo "CustomLog ${APACHE_LOG_DIR}/access.log combined">>/etc/apache2/sites-available/default
echo "</VirtualHost>" >> /etc/apache2/sites-available/default
a2ensite default
#a2ensite default-ssl
#a2enmod ssl
a2dismod ssl
a2enmod rewrite
service apache2 restart
service memcached start
cp /vagrant/flask_memcaced_test1.py /var/www/.
chmod 550 /var/www/flask_memcaced_test1.py
/usr/bin/python /var/www/flask_memcaced_test1.py &
sed -i '/exit 0/d' /etc/rc.local
echo "service memcached start" >> /etc/rc.local
echo "service apache2 start">>/etc/rc.local
echo "/usr/bin/python /var/www/flask_memcaced_test1.py &" >> /etc/rc.local
echo "exit 0">>/etc/rc.local
chmod u+x /etc/rc.local
update-rc.d  rc.local enable 2345

