FROM     ragesaq/grafana:latest

# Copy the import script

COPY conf/grafana.ini /etc/grafana/grafana.ini
COPY conf/grafana.db /var/lib/grafana/grafana.db
RUN chmod 0644 /var/lib/grafana/grafana.db
