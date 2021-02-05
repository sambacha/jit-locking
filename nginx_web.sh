add_website_to_nginx() {
    echo -n "Adding site to nginx... "
    NGINX_VERSION="$(/usr/sbin/nginx -v 2>&1 | sed 's,^nginx version: nginx/\([^ ]*\).*,\1,')"
    # The 'default_server' option is just 'default' in earlier
    # versions of nginx:
    if dpkg --compare-versions "$NGINX_VERSION" lt 0.8.21
    then
        DEFAULT_SERVER_OPTION=default
    else
        DEFAULT_SERVER_OPTION=default_server
    fi
    NGINX_SITE="$HOST"
    if [ "$DEFAULT_SERVER" = true ]
    then
        NGINX_SITE=default
    fi
    NGINX_SITE_FILENAME=/etc/nginx/sites-available/"$NGINX_SITE"
    NGINX_SITE_LINK=/etc/nginx/sites-enabled/"$NGINX_SITE"
    cp $CONF_DIRECTORY/nginx.conf.example $NGINX_SITE_FILENAME
    sed -i "s,/var/www/$SITE,$DIRECTORY," $NGINX_SITE_FILENAME
    if [ "$DEFAULT_SERVER" = true ]
    then
        sed -i "s/^.*listen 80.*$/    listen 80 $DEFAULT_SERVER_OPTION;/" $NGINX_SITE_FILENAME
    else
        sed -i "/listen 80/a\
\    server_name $HOST;
" $NGINX_SITE_FILENAME
    fi
    ln -nsf "$NGINX_SITE_FILENAME" "$NGINX_SITE_LINK"
    make_log_directory
    /usr/sbin/service nginx restart >/dev/null
    echo $DONE_MSG
}