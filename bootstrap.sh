#!/usr/bin/env bash
debconf-set-selections <<< 'mysql-server mysql-server/root_password password damnvulnerablewp'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password damnvulnerablewp'
apt-get update
apt-get -y install mysql-server mysql-client
apt-get -y install tor proxychains clamav nmap ngrep unzip ngrok-client
add-apt-repository -y ppa:nginx/stable
apt-get update
apt-get install -y nginx
apt-get install -y php5-cli php5-common php5-mysql php5-gd php5-fpm php5-cgi php5-fpm php-pear php5-mcrypt
apt-get -f install -y
#freshclam -v
/etc/init.d/nginx stop
/etc/init.d/php5-fpm stop

sed -i 's/^;cgi.fix_pathinfo.*$/cgi.fix_pathinfo = 0/g' /etc/php5/fpm/php.ini
sed -i 's/^;security.limit_extensions.*$/security.limit_extensions = .php .php3 .php4 .php5/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^;listen\s.*$/listen = \/var\/run\/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^listen.owner.*$/listen.owner = www-data/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^listen.group.*$/listen.group = www-data/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/^;listen.mode.*$/listen.mode = 0660/g' /etc/php5/fpm/pool.d/www.conf

cat << 'EOF' > /etc/nginx/sites-enabled/default
server
{
    listen  80;
    root /var/www/html;
    index index.php index.html index.htm;
    #server_name localhost
    location "/"
    {
        index index.php index.html index.htm;
        #try_files $uri $uri/ =404;
    }

    location ~ \.php$
    {
        include /etc/nginx/fastcgi_params;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
    }
}
EOF
/etc/init.d/mysql start
/etc/init.d/php5-fpm start
/etc/init.d/nginx start
mysql -u root -p"damnvulnerablewp" -e "CREATE DATABASE wordpress;"
mysql -u root -p"damnvulnerablewp" -e "CREATE USER wordpress@localhost IDENTIFIED BY 'damnvulnerablewp';"
mysql -u root -p"damnvulnerablewp" -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost;"
mysql -u root -p"damnvulnerablewp" -e "FLUSH PRIVILEGES;"

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp
chmod +x /tmp/wp
mv -v /tmp/wp /usr/local/bin/wp
chown -v 0755 /usr/local/bin/wp
wp core download --path=/var/www/html --allow-root --version=4.7
wp core config --path=/var/www/html --dbname=wordpress --dbuser=wordpress --dbpass=damnvulnerablewp --allow-root
wp core install --path=/var/www/html --url=http://damnvulnerablewordpress.dev --title=damn-vulnerable-wp --admin_user=admin --admin_email=nobody@nowhere.tld --admin_password=password --allow-root

chown -R www-data. /var/www/html
rm /var/www/html/index.nginx-debian.html
printf "Setup complete!!\n===WP-ADMIN LOGIN INFORMATION===\nUser: admin\nPass: password"
printf "Create this hosts file entry:\n$(ip a | grep eth2 | grep inet | awk {'print $2'}| cut -d \/ -f1)\tdamnvulnerablewordpress.dev"
printf "Rebooting.....\n"
reboot
