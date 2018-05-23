#!/bin/bash
kubectl delete -f redis-service.yaml
kubectl delete -f redis-statefulset.yaml
kubectl delete configmap redis-config
./create-configmap.sh
kubectl apply -f redis-statefulset.yaml
kubectl apply -f redis-service.yaml