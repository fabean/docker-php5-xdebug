#!/bin/bash

# Need env vars:
# CONF_REPO
# CONF_REPO_BRANCH

if [[ -n "$CONF_REPO" && ! -z $CONF_REPO ]] ; then
  # Clone CONF_REPO to /root/configs
  mkdir -p /root/configs
  git clone -b $CONF_REPO_BRANCH $CONF_REPO /root/configs
  
  grep -q -F '/root/configs' /root/crons.conf || echo "*/15 * * * * . /root/project_env.sh; cd /root/configs && git pull origin $CONF_REPO_BRANCH" >> /root/crons.conf
  
  if [[ -e /root/configs/000-default.conf ]] ; then
    cp /root/configs/000-default.conf /etc/apache2/sites-enabled/000-default.conf
  fi
  
  if [[ -e /root/configs/php.ini ]] ; then
    cp /root/configs/php.ini /etc/php5/fpm/php.ini
    supervisorctl restart php-fpm
  fi
fi
