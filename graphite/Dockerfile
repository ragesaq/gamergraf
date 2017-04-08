# Graphite stack

# Build from Ubuntu base
FROM ragesaq/base

# This suppresses a bunch of annoying warnings from debconf
ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN \
    apt-get update -y && \
    apt-get install -y --no-install-recommends python-minimal supervisor libffi6 libcairo2 collectd curl libcurl3 libcurl3-gnutls libxml2 libxml2-utils xml-core &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Install Python packages for Graphite
# Install devel packages only to allow compilation on PIP install

RUN \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        g++ \
        python-dev \
        python-six \
        libcairo2-dev \
        libffi-dev \
        python-pip \
    && \
    pip install \
        gunicorn \
        graphite-api[sentry] \
        whisper \
        carbon \
    && \
    apt-get purge --auto-remove -y \
        g++ \
        python-dev \
        python-pip \
        libcairo2-dev \
        libffi-dev \
    && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Optional install graphite-api caching
# http://graphite-api.readthedocs.org/en/latest/installation.html#extra-dependencies
# RUN pip install -y graphite-api[cache]

# Graphite
COPY conf/graphite/ /opt/graphite/conf/
# Supervisord
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Graphite API
COPY conf/graphite-api.yaml /etc/graphite-api.yaml
# Collectd
COPY conf/collectd-conf.sh /etc/collectd/collectd-conf.sh
#entrypoint
COPY entrypoint.sh /etc/collectd/
# nginx
EXPOSE \
# graphite-api
8000 \
# Carbon line receiver
2003 \
# Carbon pickle receiver
2004 \
# Carbon cache query
7002

VOLUME ["/opt/graphite/conf", "/opt/graphite/storage/whisper"]
RUN chmod +x /etc/collectd/collectd-conf.sh
RUN chmod +x /etc/collectd/entrypoint.sh
RUN rm /etc/collectd/collectd.conf
# Launch stack
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT ["/etc/collectd/entrypoint.sh"]
