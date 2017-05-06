# damn-vulnerable-wordpress
This vagrant environment will allow you to spin up a WordPress implementation with:
- php5-fpm
- MySQL
- WordPress core 4.7
- nginx


## passwords
MySQL
```
mysql -u root -p"damnvulnerablewp" -e "CREATE DATABASE wordpress;"
mysql -u root -p"damnvulnerablewp" -e "CREATE USER wordpress@localhost IDENTIFIED BY 'damnvulnerablewp';"
mysql -u root -p"damnvulnerablewp" -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpress@localhost;"
mysql -u root -p"damnvulnerablewp" -e "FLUSH PRIVILEGES;"
```

WordPress
admin:password
