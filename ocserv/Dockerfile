FROM debian:10-slim

MAINTAINER Ali Beglu <ali.beglu@gmail.com>

RUN echo "deb http://http.us.debian.org/debian/ testing non-free contrib main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y ocserv procps iptables less 

COPY ocserv.conf /etc/ocserv/ocserv.conf
COPY scripts /scripts
COPY entrypoint.sh /

EXPOSE 443

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]

