add_locale() {
    # Adds a specific UTF-8 locale (with Ubuntu you can provide it on the
    # command line, but Debian requires a file edit)

    echo -n "Generating locale $1... "
    if [ "$(locale -a | egrep -i "^$1.utf-?8$" | wc -l)" = "1" ]
    then
        notice_msg already
    else
        if [ x"$DISTRIBUTION" = x"ubuntu" ]; then
            locale-gen "$1.UTF-8"
        elif [ x"$DISTRIBUTION" = x"debian" ]; then
            if [ x"$(grep -c "^$1.UTF-8 UTF-8" /etc/locale.gen)" = x1 ]
            then
                notice_msg generating...
            else
                notice_msg adding and generating...
                printf "\n$1.UTF-8 UTF-8\n" >> /etc/locale.gen
            fi
            locale-gen
        fi
    fi
    echo $DONE_MSG
}

generate_locales() {
    echo "Generating locales... "
    # If language-pack-en is present, install that:
    apt-get -qq install -y language-pack-en >/dev/null || true
    add_locale en_GB
    echo $DONE_MSG
}

set_locale() {
    echo 'LANG="en_GB.UTF-8"' > /etc/default/locale
    echo 'LC_ALL="en_GB.UTF-8"' >> /etc/default/locale
    export LANG="en_GB.UTF-8"
    export LC_ALL="en_GB.UTF-8"
}

add_unix_user() {
    echo -n "Adding unix user... "
    # Create the required user if it doesn't already exist:
    if id "$UNIX_USER" 2> /dev/null > /dev/null
    then
        notice_msg already
    else
        adduser --quiet --disabled-password --gecos "A user for the site $SITE" "$UNIX_USER"
    fi
    echo $DONE_MSG
}

add_postgresql_user() {
    SUPERUSER=${1:---no-createrole --no-superuser}
    su -l -c "createuser --createdb $SUPERUSER '$UNIX_USER'" postgres || true
}