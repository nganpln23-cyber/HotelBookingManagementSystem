#!/bin/sh
# Wrap -DDB_URL in single quotes so eval in catalina.sh treats & as literal
export CATALINA_OPTS="$CATALINA_OPTS '-DDB_URL=${DB_URL}' -DDB_USERNAME=${DB_USERNAME} -DDB_PASSWORD=${DB_PASSWORD} -DMAIL_USERNAME=${MAIL_USERNAME} -DMAIL_PASSWORD=${MAIL_PASSWORD}"
