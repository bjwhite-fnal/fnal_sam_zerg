
# Dockerfile for the SAMWeb Server

FROM docker.io/library/python:3.6

RUN apt-get update && apt-get -y install gettext-base net-tools dnsutils postgresql-client && apt-get clean
RUN pip install --upgrade pip setuptools
RUN pip install remote-pdb

# Copy SAM code into image.
COPY ./sam-web /opt/sam/samweb_server/sam-web

# Copy SAM configuration files into image
COPY ./config/samweb_server.conf.template /opt/sam/samweb_server/samweb_server.conf.template
COPY ./config/file_schema_mapping.json /opt/sam/samweb_server/file_schema_mapping.json
COPY ./config/uwsgi_sam_bjwhite.ini /opt/sam/samweb_server/uwsgi_sam_bjwhite.ini
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /opt/sam/samweb_server/sam-web

RUN pip install --no-cache-dir -r requirements.txt pytest uwsgi

EXPOSE 4444

ENTRYPOINT [ "/docker-entrypoint.sh" ]
