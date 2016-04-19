FROM centos:7
MAINTAINER "Ajeet S Raina" <Ajeet_Raina@dell.com>

ADD nagios-installer.sh /
RUN sh nagios-installer.sh
ADD supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord"]

