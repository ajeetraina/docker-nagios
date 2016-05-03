<h1>docker-nagios</h1>

Docker container for Nagios 4.0.8 which includes Plugin 2.0.3<br>

<h1>Usage:</h1>

To run container use the command below:<br>

docker run -d --net=host ajeetraina/docker-nagios<br>

Open up http://<ip>/nagios with the following credentials:<br>

nagiosadmin/nagiosadmin<br>

<h1>How to access the container?</h1><br>

$ docker exec -it container_id  /bin/bash
