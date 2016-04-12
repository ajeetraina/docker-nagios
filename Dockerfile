FROM centos:7
MAINTAINER "Ajeet S Raina" <Ajeet_Raina@dell.com>

ENV Packages epel-release mod_ssl nagios nagios-plugins-all postfix && \
		mod_ssl nagios nagios-plugins-all postfix && \
		wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp

ENV NAG_VERSION 4.0.1
ENV NAGIOS_PLUGIN_VERSION 1.5
ENV NAG_USER nagios
ENV NAG_GROUP nagios
ENV NAG_CMDGROUP nagcmd
ENV NAG_APACHE apache
ENV NAGADMIN_USER nagiosadmin
ENV NAGADMIN_PASS nagios
ENV NAGADMIN_EMAIL nagios@localhost
ENV NAG_HOME /usr/local/nagios

#Installing Required Packages
RUN yum update -y $Packages

#Adding Nagios User and Group
RUN useradd ${NAG_USER}  && \
    groupadd ${NAG_GROUP} && \
    usermod -a -G ${NAG_CMDGROUP} ${NAG_USER}  
    usermode -a -G ${NAG_CMDGROUP} ${NAG_APACHE}

WORKDIR $NAG_HOME

RUN wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.1.tar.gz
RUN wget https://www.nagios-plugins.org/download/nagios-plugins-1.5.tar.gz


RUN cd NAG_HOME  && \
    tar zxf nagios-4.0.1.tar.gz  && \
    cd nagios-4.0.1 && \
    ./configure --with-command-group=${NAGIOS_CMDGROUP}   

&& \
    make all  && \
    make install  && \
    make install-init  && \
    make install-config  && \
    make install-commandmode  && \
    make install-webconf  
    



# Compile and install Nagios Plugins
RUN cd NAG_HOME  && \
    tar zxf nagios-plugins-1.5.tar.gz  && \
    cd nagios-plugins-1.5  && \
    ./configure --with-nagios-user=${NAG_USER} --with-nagios-group=${NAG_GROUP}  && \
    make  && \
    make install  && \
    
RUN cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
RUN chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
RUN /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

# config test
RUN /etc/init.d/nagios configtest

# Start supporting services
RUN systemctl start nagios
RUN systemctl start httpd
RUN systemctl restart httpd

RUN htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
WORKDIR  NAG_HOME/nagios-plugins-1.5
RUN ./configure --with-nagios-user=nagios --with-nagios-group=nagios
RUN make && make install
RUN chkconfig --add nagios
RUN chkconfig --level 35 nagios on
RUN chkconfig --add httpd
RUN chkconfig --level 35 httpd on

EXPOSE 80/tcp
