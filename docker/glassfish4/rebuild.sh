#!/bin/bash
SRC_PKG=MavenEnterpriseApp.zip
SRC_URL=https://netbeans.org/project_downloads/samples/Samples/JavaEE/MavenEnterpriseApp.zip
SRC_DIR=application/
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Stopping and removing any existing container with the same name...${NC}"
docker stop glassfish4
docker rm glassfish4
docker rmi -f benwilcock/glassfish:4.1.2

echo -e "${RED}Downloading and building the JEE application source code...${NC}"
curl -O $SRC_URL
unzip -oq $SRC_PKG -d $SRC_DIR
rm -f $SRC_PKG
pushd .
cd $SRC_DIR
docker run -it --rm --name my-maven-project -v "$(pwd)":/usr/src/mymaven -w /usr/src/mymaven maven:3.5-jdk-7-alpine mvn clean install
# mvn clean install
popd
mv application/MavenEnterpriseApp-ear/target/MavenEnterpriseApp-ear.ear .
rm -rf $SRC_DIR

echo -e "${RED}Building and running the docker image (includes configuring Glassfish APP, DB and JMS)...${NC}"
docker build -t benwilcock/glassfish:4.1.2 .
rm -f MavenEnterpriseApp-ear.ear
docker run -it --name glassfish4 --rm -e ADMIN_PASSWORD=password -p 4848:4848 -p 8080:8080 -d benwilcock/glassfish:4.1.2
echo -e "${RED}Starting Glassfish now. Wait a few minutes and then navigate to http://localhost:8080/MavenEnterpriseApp-web/ListNews ${NC}"
docker logs -f glassfish4