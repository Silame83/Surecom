FROM nginx

RUN mkdir -p /spool/logs/ && touch /spool/logs/nginx-access.log
ADD script.sh /
RUN bash -c "/script.sh"

EXPOSE 80 443
