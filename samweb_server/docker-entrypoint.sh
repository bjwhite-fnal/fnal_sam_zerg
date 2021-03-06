#!/bin/sh

# ensure samweb is properly set up to run
pip install --no-deps --no-cache-dir -e /opt/sam/samweb_server/sam-web

# Get the database password from the secret
export DBPASS=$(cat /run/secrets/samweb_db_secret)
# Get the web server ip address that we need to give back to clients outside the Docker network
export SAM_ZERG_APACHE_IP=$(nslookup sam_zerg_apache_1 | grep -A2 "Non-authoritative" | tail -1 | awk '{print $NF}')
envsubst < /opt/sam/samweb_server/samweb_server.conf > /opt/sam/samweb_server/samweb_server.conf

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec uwsgi --ini /opt/sam/samweb_server/uwsgi_sam_bjwhite.ini
fi
