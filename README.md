<h1>docker-nagios</h1>

Docker container for Nagios 4.0.8 which includes Dell check_openmanage plugin <br>

<h1>Usage:</h1>

To run container use the command below:<br>

docker run -d --net=host ajeetraina/docker-nagios<br>

Open up http://Host IP/nagios with the following credentials:<br>

nagiosadmin/nagiosadmin<br>

<h1>Where shall I look to monitor Dell Hardware?</h1><br>

Open up Nagios UI > Go to Hostgroup > Summary > Physical Health
