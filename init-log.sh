make_log_directory() {
    LOG_DIRECTORY="$DIRECTORY/logs"
    mkdir -p "$LOG_DIRECTORY"
    chown -R "$UNIX_USER"."$UNIX_USER" "$LOG_DIRECTORY"
}
