#!/bin/bash

# From the docs: https://docs.spring.io/spring-cloud-dataflow/docs/current-SNAPSHOT/reference/htmlsingle/#api-guide-resources-stream-definitions
# curl -X POST -d "name=ticktock&definition=time | log" localhost:9393/streams/definitions?deploy=false

rm -rf ./in/*
rm -rf ./out/*
sleep 1

curl 'http://localhost:9393/streams/definitions' -i -X POST -d 'name=file-ingest-and-split&definition=file-in: file --directory=/files/in --filename-pattern=*.txt --mode=lines | uppercase: transform --expression=payload.toUpperCase() | files-out: file --directory=/files/out --name-expression="T(Math).random()"&deploy=true'

curl 'http://localhost:9393/streams/definitions' -i -X POST -d 'name=log-by-line&definition=:file-ingest-and-split.uppercase > log-by-line: log&deploy=true'

echo -e "\nWaiting for deployments to happen (for 60 seconds), before copying the names.txt file to the ./in folder..."
sleep 60
cp names.txt ./in

echo -e "\nListing file contents of files in the ./out folder (in 10 seconds)..."
sleep 10
find ./out | while read l ; do cat $l ;echo ; done