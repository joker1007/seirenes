FROM ubuntu:12.04

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get -y install mysql-server

ADD ./setup.sh /opt/setup.sh
RUN chmod 755 /opt/setup.sh
RUN /bin/bash /opt/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/bin/mysqld_safe"]
