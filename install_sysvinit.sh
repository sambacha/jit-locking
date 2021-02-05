install_sysvinit_script() {
    if [ "$SYSTEMD" = true ] && [ -e $CONF_DIRECTORY/systemd.example ]; then
      INIT_FILENAME=/etc/systemd/system/${SITE}.service
      cp $CONF_DIRECTORY/systemd.example $INIT_FILENAME
    else
      INIT_FILENAME=/etc/init.d/$SITE
      cp $CONF_DIRECTORY/sysvinit.example $INIT_FILENAME
    fi
    sed -i "s,/var/www/$SITE,$DIRECTORY,g" $INIT_FILENAME
    sed -i "s/^ *\(U[Ss][Ee][Rr]\)=.*/\1=$UNIX_USER/" $INIT_FILENAME
    if [ "$SYSTEMD" = true ] && [ -e $CONF_DIRECTORY/systemd.example ]; then
      /bin/systemctl daemon-reload
      /bin/systemctl enable $SITE
    else
      chmod a+rx $INIT_FILENAME
      update-rc.d $SITE defaults
    fi
    if [ ! "$DOCKER" = true ]; then
        # We don't want to try and start services during the build.
        /usr/sbin/service $SITE restart
    fi
}