#!/bin/bash
docker stop glassfish5
docker rm glassfish5
docker rmi -f benwilcock/glassfish:5.0
docker build -t benwilcock/glassfish:5.0 .
docker run --name glassfish5 -ti -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -d benwilcock/glassfish:5.0