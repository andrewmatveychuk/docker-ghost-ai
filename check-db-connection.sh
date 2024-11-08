#!/bin/sh
set -e

# If database is MySQL, wait the database backend to be up and running
if [ "$database__client" = "mysql" ]; then

  while ! mysqladmin ping \
    --host="$database__connection__host" \
    --port="${database__connection__port:=3306}" \
    --user="$database__connection__user" \
    --password="$database__connection__password" \
    --silent; do
    echo "Waiting for 30 sec for a reply from MySQL server [$database__connection__host:$database__connection__port] ..."
    sleep 30
  done
  echo "MySQL is up!"

fi

echo "Executing the original Ghost container entrypoint script..."

/usr/local/bin/docker-entrypoint.sh

exec "$@"
