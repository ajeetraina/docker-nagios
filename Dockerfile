FROM centos:7
MAINTAINER "Ajeet S Raina" <Ajeet_Raina@dell.com>

ADD nagios-installer.sh /
RUN sh nagios-installer.sh
EXPOSE 25 80
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]

