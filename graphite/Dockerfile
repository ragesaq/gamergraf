# Graphite stack

# Build from Ubuntu base
FROM ubuntu:18.04

# This suppresses a bunch of annoying warnings from debconf
ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN \
    apt-get update -y && \
    apt-get install -y vim\
     supervisor\
     collectd\
     curl\
     expect\
     g++\
     libcairo2\
     libcairo2-dev \
     libcurl4\
     libffi6\
     libffi-dev \
     libxml2\
     libxml2-utils\
     pkg-config\
     python-cairo\
     python-dev\
     python-flup\
     python-minimal\
     python-six\
     python-setuptools\
     python-pip\
     xml-core &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Install Python packages for Graphite
# Install devel packages only to allow compilation on PIP install

RUN \
export PYTHONPATH="/opt/graphite/lib/:/opt/graphite/webapp/" \
&& \
    pip install --no-binary=:all: https://github.com/graphite-project/whisper/tarball/master \
&& \
    pip install --no-binary=:all: https://github.com/graphite-project/carbon/tarball/master \
&& \
    pip install --no-binary=:all: https://github.com/graphite-project/graphite-web/tarball/master \
&& \
    pip install \
        gunicorn \
        graphite-api[sentry] \
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

VOLUME ["/opt/graphite/conf", "/opt/graphite/storage"]
RUN chmod +x /etc/collectd/collectd-conf.sh
RUN chmod +x /etc/collectd/entrypoint.sh
RUN rm /etc/collectd/collectd.conf
# Launch stack
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT ["/etc/collectd/entrypoint.sh"]
