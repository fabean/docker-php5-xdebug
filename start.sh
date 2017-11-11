#!/bin/bash

# Run Confd to make config files
/usr/local/bin/confd -onetime -backend env

# Export all env vars containing "_" to a file for use with cron jobs
printenv | grep \_ | sed 's/^\(.*\)$/export \1/g' | sed 's/=/=\"/' | sed 's/$/"/g' > /root/project_env.sh
chmod +x /root/project_env.sh

# Add gitlab to hosts file
grep -q -F "$GIT_HOSTS" /etc/hosts  || echo $GIT_HOSTS >> /etc/hosts

# Add cron jobs
if [[ -n "$GIT_REPO" ]] ; then
  sed -i "/drush/s/^\w*/$(echo $GIT_REPO | md5sum | grep -P '[0-5][0-9]' -o | head -1)/" /root/crons.conf
fi
if [[ ! -n "$PRODUCTION" || $PRODUCTION != "true" ]] ; then
  sed -i "/git pull/s/[0-9]\+/5/" /root/crons.conf
fi

# Clone repo to container
git clone --depth=1 -b $GIT_BRANCH $GIT_REPO /var/www/site/

echo "[$(date +"%Y-%m-%d %H:%M:%S:%3N %Z")] NOTICE: Setting up XDebug based on state of LOCAL envvar"
if [[ -n "$LOCAL" &&  $LOCAL = "true" ]] ; then
  /usr/bin/apt-get update && apt-get install -y \
    php5-xdebug \
    --no-install-recommends && rm -r /var/lib/apt/lists/*
  cp /root/xdebug-php.ini /etc/php5/fpm/php.ini
  /usr/bin/supervisorctl restart php-fpm
fi

# Install appropriate apache config and restart apache
if [[ -n "$WWW" &&  $WWW = "true" ]] ; then
  cp /root/wwwsite.conf /etc/apache2/sites-enabled/000-default.conf
fi


# Load configs
/root/load-configs.sh

# set permissions on php log
chmod 640 /var/log/php5-fpm.log
chown www-data:www-data /var/log/php5-fpm.log

crontab /root/crons.conf
/usr/bin/supervisorctl restart apache2
