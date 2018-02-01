FROM docker.elastic.co/elasticsearch/elasticsearch:6.1.3
LABEL maintainer="matthias.zimmermann@adcubum.com"

# add config file
COPY --chown=elasticsearch:elasticsearch config.json /usr/share/elasticsearch/config

# copy synonym file
RUN mkdir /usr/share/elasticsearch/config/analysis
COPY --chown=elasticsearch:elasticsearch synonym.txt /usr/share/elasticsearch/config/analysis

# copy sample documents
RUN mkdir /usr/share/elasticsearch/config/documents
COPY --chown=elasticsearch:elasticsearch doc.bb8.json /usr/share/elasticsearch/config/documents
COPY --chown=elasticsearch:elasticsearch doc.milleniumfalcon.json /usr/share/elasticsearch/config/documents
COPY --chown=elasticsearch:elasticsearch doc.tiefighter.json /usr/share/elasticsearch/config/documents

# copy init script
COPY --chown=elasticsearch:elasticsearch initialize.sh /usr/share/elasticsearch/
