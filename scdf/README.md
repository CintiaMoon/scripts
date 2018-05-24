# Spring Cloud Dataflow sample

1. Requires Docker to be installed and to be running
1. Uses a file based flow, which requires mapping and binding the volumes in Docker

## Getting started

As a convenience I've added a bash script to download the dataflow bits that you need...

```bash
./get-dataflow.sh
```

Read on for the small mod you need to make to `docker-compose.yml` if you want to follow along.

## Start the data-flow servers

```bash
./start-dataflow.sh
```

## Run the file based sample

This sample will create a file based data-flow on the server. It... 

1. Checks the `/in` folder for a file named `names.txt`
1. When the file appears it reads it and splits out each line in the file
1. It processes each line, making each line uppercase
1. It writes each line out as a separate file into the `/out` folder

#### Setting up the file based flow

To follow this example, you'll need to map the `in` and `out` folders to the Docker containers by modifying the `docker-compose.yml` that defines the `dataflow-server:` as follows (binding the `volumes` as required).

```yaml
  dataflow-server:
    ...
    volumes:
      - type: bind
        source: ./in
        target: /files/in
      - type: bind
        source: ./out
        target: /files/out
```

#### Create and run the file-based data-flow

```bash
./create-stream.sh 
```

## Check the log

```bash
java -jar shell.jar
dataflow> runtime apps

# Stuff omitted for brevity...
╟┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┼┈┈┈┈┈┈┈┈┈┈┈┼┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈╢
║                                 │           │       guid = 27505                                                                                                                          ║
║                                 │           │        pid = 1351                                                                                                                           ║
║                                 │           │       port = 27505                                                                                                                          ║
║log-by-line.log-by-line-0        │ deployed  │     stderr = /tmp/spring-cloud-deployer-1652829348155589225/log-by-line-1527185815355/log-by-line.log-by-line/stderr_0.log                  ║
║                                 │           │     stdout = /tmp/spring-cloud-deployer-1652829348155589225/log-by-line-1527185815355/log-by-line.log-by-line/stdout_0.log                  ║
║                                 │           │        url = http://172.18.0.4:27505                                                                                                        ║
║                                 │           │working.dir = /tmp/spring-cloud-deployer-1652829348155589225/log-by-line-1527185815355/log-by-line.log-by-line                               ║
╚═════════════════════════════════╧═══════════╧═════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

exit
```

Now `tail` the `stdout` for the `log-by-line.log-by-line-0` runtime by connecting to the `dataflow-server` shell as follows...

```bash
docker exec -it dataflow-server /bin/sh
/ # tail -f /tmp/spring-cloud-deployer-1652829348155589225/log-by-line-1527185815355/log-by-line.log-by-line/stdout_0.log

2018-05-24 18:17:56.201  INFO 1351 --- [           -L-1] log-sink                                 : ALICE
2018-05-24 18:17:56.202  INFO 1351 --- [           -L-1] log-sink                                 : FRED
2018-05-24 18:17:56.202  INFO 1351 --- [           -L-1] log-sink                                 : BOB
2018-05-24 18:17:56.203  INFO 1351 --- [           -L-1] log-sink                                 : TIBERIUS
2018-05-24 18:17:56.207  INFO 1351 --- [           -L-1] log-sink                                 : HENRY
2018-05-24 18:17:56.208  INFO 1351 --- [           -L-1] log-sink                                 : LIAM
2018-05-24 18:17:56.208  INFO 1351 --- [           -L-1] log-sink                                 : ISOBEL
2018-05-24 18:17:56.212  INFO 1351 --- [           -L-1] log-sink                                 : LINDA
2018-05-24 18:17:56.212  INFO 1351 --- [           -L-1] log-sink                                 : BRIAN
2018-05-24 18:17:56.212  INFO 1351 --- [           -L-1] log-sink                                 : DAVE
```