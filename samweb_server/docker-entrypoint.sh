#!/bin/sh

# ensure samweb is properly set up to run
pip install --no-deps --no-cache-dir -e /opt/sam/samweb_server/sam-web

# Get the database password from the secret (only for podman, otherwise use envar from secret mount)
if [ -f /run/secrets/samweb_db_secret ]; then
    export DB_PASS=$(cat /run/secrets/samweb_db_secret)
    echo "Set the database password from the secret to: $DBPASS"
fi

# Replace placeholders in configuration file with runtime values.
envsubst < /opt/sam/samweb_server/samweb_server.conf.template > /opt/sam/samweb_server/samweb_server.conf
echo "SAM Web Server configuration:\n$(cat /opt/sam/samweb_server/samweb_server.conf)"

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec uwsgi --ini /opt/sam/samweb_server/uwsgi_sam_bjwhite.ini
fi
