# Kubernetes Minikube Notes

Installation on Mac OSX...

````bash
$ brew install xhyve
$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64 &&   \
$ chmod +x minikube && \
$ sudo mv minikube /usr/local/bin/
$ minikube --version
$ brew install docker-machine-driver-xhyve
$ sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
$ sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
$ brew install kubectl
$ curl --proxy "" https://cloud.google.com/container-registry/
````

That last command should tell you that you can browse the web without a proxy.

## Starting and Stopping Minikube

To start the local Minikube cluster (with Docker running and no need for a http proxy)...

````bash
$ minikube start --vm-driver=xhyve
````

Then set the kubectl context. You can see all your available contexts in the `~/.kube/config` file.

````bash
$ kubectl config use-context minikube
````

Then verify `kubectl` is working with Minikube...

````bash
$ kubectl cluster-info
````

To stop Minikube use...

````bash
$ minikube stop
````
