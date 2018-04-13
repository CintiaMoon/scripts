## Installing Riff CLI

Docs in the tutorial were wrong. Correct way was...

```bash
curl -Lo riff-darwin-amd64.tgz https://github.com/projectriff/riff/releases/download/v0.0.6/riff-darwin-amd64.tgz
tar xvzf riff-darwin-amd64.tgz
sudo mv riff /usr/local/bin/
```


```bash
  537  minikube start --memory=4096
  538  helm init
  539  helm repo add projectriff https://riff-charts.storage.googleapis.com
  540  helm repo update
  541  helm install projectriff/riff   --name projectriff   --namespace riff-system   --set kafka.create=true   --set rbac.create=false   --set httpGateway.service.type=NodePort
  542  go get github.com/projectriff/riff
  543  riff
  544  riff invokers apply -f https://github.com/projectriff/node-function-invoker/raw/v0.0.6/node-invoker.yaml
  545  riff invokers apply -f https://github.com/projectriff/command-function-invoker/raw/v0.0.6/command-invoker.yaml
  546  riff invokers apply -f https://github.com/projectriff/java-function-invoker/raw/v0.0.5-sr.1/java-invoker.yaml
```

## Watch the `riff-system` in Kubernetes...

```bash
watch -n 1 kubectl get po,deploy --namespace riff-system
```
