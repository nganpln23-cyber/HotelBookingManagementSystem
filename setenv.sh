#!/bin/sh
# Escape & in DB_URL because catalina.sh uses eval which treats & as background operator
DB_URL_ESC=$(printf '%s' "${DB_URL}" | sed 's/&/\\&/g')
export CATALINA_OPTS="$CATALINA_OPTS -DDB_URL=${DB_URL_ESC} -DDB_USERNAME=${DB_USERNAME} -DDB_PASSWORD=${DB_PASSWORD} -DMAIL_USERNAME=${MAIL_USERNAME} -DMAIL_PASSWORD=${MAIL_PASSWORD}"
