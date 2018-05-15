#!/bin/bash
docker stop glassfish
docker rm glassfish
docker rmi -f benwilcock/glassfish:4.1.2
mvn clean install
docker build -t benwilcock/glassfish:4.1.2 .
docker run --name glassfish -ti -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -d benwilcock/glassfish:4.1.2
docker logs glassfish