<h1>docker-nagios</h1>

Docker container for Nagios 4.0.8 which includes Plugin 2.0.3

<h1>Usage:</h1>

To run container use the command below:

docker run -d -p 80:80 -p 25:25 ajeetraina/docker-nagios
Open up http://<ip>/nagios with the following credentials:

nagiosadmin/nagiosadmin

<h1>How to access the container?</h1>

$ docker exec -it container_id  /bin/bash
