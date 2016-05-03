# This script installs Nagios 4.0.8 and Nagios Plugin 2.0.3 on Centos 7.0 system.

#Updating the OS along with required packages.
yum -y update
yum install -y epel-release
yum -y install make gd gd-devel supervisor* supervisord wget sendmail* httpd php gcc perl 


# Create Nagios users and groups
adduser nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
usermod -a -G nagios apache


#Dumping Nagios files under /root as  I could see issues with /opt/Nagios oR /usr/local/nagios.
cd /root/

# Download Nagios Bits
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.0.8.tar.gz
wget http://nagios-plugins.org/download/nagios-plugins-2.0.3.tar.gz

# Building the Nagios tool
tar xf nagios-4.0.8.tar.gz
cd nagios-4.0.8/
./configure --with-command-group=nagcmd
make all; make install
make install-init; make install-config
make install-commandmode; make install-webconf

# Configure email and htuser,nagiosadmin/nagiosadmin as credential for Nagios UI
sed -i 's/nagios@localhost/ajeetraina@collabnix/g' /usr/local/nagios/etc/objects/contacts.cfg
echo "nagiosadmin:M.t9dyxR3OZ3E" > /usr/local/nagios/etc/htpasswd.users

# Installing Nagios plugins
cd /root/
tar xf nagios-plugins-2.0.3.tar.gz
cd nagios-plugins-2.0.3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make; make install

# Add/enable nagios in systemd
#systemctl status nagios.service
#ystemctl enable nagios.service
#chkconfig --list

# Create initial config
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

# Some bug fixes
touch /var/www/html/index.html
chown nagios.nagcmd /usr/local/nagios/var/rw
chmod g+rwx /usr/local/nagios/var/rw
chmod g+s /usr/local/nagios/var/rw
chmod u+s /bin/ping

# Init script bug fix
sed -i '/$NagiosBin -d $NagiosCfgFile/a (sleep 10; chmod 666 \/usr\/local\/nagios\/var\/rw\/nagios\.cmd) &'  /etc/init.d/nagios

#Bit of fix recommended by few Nagios IRC folks
#yum remove -y gcc 
yum install -y nagios-plugins-openmanage nagios-plugins-all
#Adding check_openmanage commands section
cat << EOF >> /usr/local/nagios/etc/objects/commands.cfg
 define command{
         command_name check_openmanage
         command_line  /usr/lib64/nagios/plugins/check_openmanage -H localhost --check storage=0 -d 20
         }
EOF

#Adding check_openmanage services section
cat << EOF >> /usr/local/nagios/etc/objects/localhost.cfg
define service{
        use                             local-service
        host_name                       localhost
        service_description             Physical Health
        check_command                   check_openmanage
}
EOF
