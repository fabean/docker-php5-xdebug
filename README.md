# docker-insuranceclicks

Custom build for PHP5 with XDEBUG
Fork of our Drupal-Legacy

Consists of Ubuntu 14.04, PHP5.5.9 (FPM) and Apache 2.4.

# Environment variables
* VIRTUAL_HOST= FQDN of website with a "." at the beginning
* WWW= "true" if the site should redirect to www.fqdn
* PRODUCTION= "true" if the site is production (affects Git pulls and drupal settings)
* GIT_HOSTS= Hosts file entry to be added
* GIT_REPO= URL of Git repo to pull from
* GIT_BRANCH= Git branch
* MYSQL_SERVER= Host name of MySQL server
* MYSQL_DATABASE= MySQL database name
* MYSQL_USER= MySQL user name
* MYSQL_PASSWORD= MySQL password
* DRUPAL_BASE_URL= Base URL for Drupal config
* DRUPAL_HTTPS= Set to on or off
* APACHE_DOCROOT= Apache Docroot - defaults to `/var/www/site/docroot`
* SESAuthUser= AWS SES SMTP username starting with 'AuthUser='
* SESAuthPass= AWS SES SMTP password starting with 'AuthPass='
* SESmailhub= AWS SES SMTP address, with port
* CONF_REPO= Repo for config files (php.ini and 000-default.conf)
* CONF_REPO_BRANCH= Branch for CONF_REPO

# BASH aliases
`mysqlc` connects to MySQL based on Environment Variables
`mysqld > file.sql` dumps database to file.sql based on Environment Variables


https://hub.docker.com/r/codekoalas/drupal8/

