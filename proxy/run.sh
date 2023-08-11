#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Setting proxy host: $(bashio::config 

bashio::log.info "Setting proxy port: $(bashio::config port)"
sed -i "s/PORT/$(bashio::config port)/g" /haproxy.cfg

if $(bashio::config.true ssl.enabled); then
	bashio::log.info "SSL communitcation to proxy enabled"
	sed -i "s/USE_SSL/ssl/g" /haproxy.cfg

	if $(bashio::config.true ssl.verify); then
		bashio::log.info "SSL verification enabled"
		sed -i "s/VERIFY_SSL//g" /haproxy.cfg
	else
		bashio::log.info "SSL verification disabled"
		sed -i "s/VERIFY_SSL/verify none/g" /haproxy.cfg
	fi

else
	bashio::log.info "SSL communitcation to proxy not enabled"
	sed -i "s/USE_SSL VERIFY_SSL//g" /haproxy.cfg
fi

bashio::log.info "Server line: $(cat /haproxy.cfg | grep 'server proxy')"

bashio::log.info "Starting haproxy"
haproxy -W -db -f /haproxy.cfg
