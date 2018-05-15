#!/bin/bash
# docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=password -d mysql:8.0.11
# docker run --name glassfish -ti -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -p 1527:1527 --link some-mysql:mysql -d oracle/glassfish:4.1.2
docker run --name glassfish -ti -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -d benwilcock/glassfish:4.1.2