#!/usr/bin/env bash

# curl -Lo riff-darwin-amd64.tgz https://github.com/projectriff/riff/releases/download/v0.0.6/riff-darwin-amd64.tgz
# tar xvzf riff-darwin-amd64.tgz
# sudo mv riff /usr/local/bin/

minikube start --memory=4096
echo "About to start a watch. Cancel it when the Minikube system looks to be in a running state..."
sleep 10

watch -n 1 kubectl get pods,daemonSets,deployments,services --namespace=kube-system

helm init
echo "About to start a watch. Cancel it when the Helm system looks to be in a running state..."
sleep 10
watch -n 1 kubectl get pods,daemonSets,deployments,services --all-namespaces

helm repo add projectriff https://riff-charts.storage.googleapis.com
helm repo update
helm install projectriff/riff --name projectriff --namespace riff-system --set kafka.create=true --set rbac.create=false --set httpGateway.service.type=NodePort

echo "About to start a watch. Cancel it when the Riff system looks to be in a running state..."
sleep 10
watch -n 1 kubectl get pods,deployments --namespace riff-system

riff invokers apply -f https://github.com/projectriff/command-function-invoker/raw/v0.0.6/command-invoker.yaml
riff invokers apply -f https://github.com/projectriff/go-function-invoker/raw/v0.0.2/go-invoker.yaml
riff invokers apply -f https://github.com/projectriff/java-function-invoker/raw/v0.0.5-sr.1/java-invoker.yaml
riff invokers apply -f https://github.com/projectriff/node-function-invoker/raw/v0.0.6/node-invoker.yaml
riff invokers apply -f https://github.com/projectriff/python2-function-invoker/raw/v0.0.6/python2-invoker.yaml
riff invokers apply -f https://github.com/projectriff/python3-function-invoker/raw/v0.0.6/python3-invoker.yaml

# echo "module.exports = (x) => x ** 2" > square/square.js
eval $(minikube docker-env)
riff create node --name square --input numbers --filepath ./square

echo "About to start a watch. Cancel it when the functions and topics look to be in a running state..."
sleep 10
watch -n 1 kubectl get functions,topics,pods,daemonSets,deployments,services --all-namespaces

echo "Sending a message to the 'square' Riff function via the 'numbers' topic and waiting for a reply..."
sleep 5
riff publish --input numbers --data 10 --reply

echo "You can delete the function and topic with 'riff delete --name square --all'"