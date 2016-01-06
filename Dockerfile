FROM elasticsearch:2.1

MAINTAINER mzhomart@gmail.com

# Override elasticsearch.yml config, otherwise plug-in install will fail
COPY config/elasticsearch-plugins.yml /elasticsearch/config/elasticsearch.yml

# Install Elasticsearch plug-ins
RUN /usr/share/elasticsearch/bin/plugin install io.fabric8/elasticsearch-cloud-kubernetes/2.1.0 --verbose

COPY config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

COPY run.sh /
