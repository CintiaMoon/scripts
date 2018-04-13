# Working with Kubernetes Clusters

## Watching what's happening...

```bash
watch -n 1 kubectl get pods,deployments --all-namespaces
```

## Getting the status of the Kubernetes `cluster` components...

```bash
kubectl get componentstatuses
NAME                 STATUS    MESSAGE              ERROR
scheduler            Healthy   ok
controller-manager   Healthy   ok
etcd-0               Healthy   {"health": "true"}
```

## Getting the status of the `nodes` in the cluster...

```bash
kubectl get nodes
NAME       STATUS    ROLES     AGE       VERSION
minikube   Ready     master    19h       v1.10.0
```

## Drilling down into the status of a `node`...

```bash
kubectl describe nodes minikube
Name:               minikube
Roles:              master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    kubernetes.io/hostname=minikube
                    node-role.kubernetes.io/master=
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  OutOfDisk        False   Thu, 12 Apr 2018 11:23:09 +0100   Wed, 11 Apr 2018 15:38:58 +0100   KubeletHasSufficientDisk     kubelet has sufficient disk space available
  MemoryPressure   False   Thu, 12 Apr 2018 11:23:09 +0100   Wed, 11 Apr 2018 15:38:58 +0100   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Thu, 12 Apr 2018 11:23:09 +0100   Wed, 11 Apr 2018 15:38:58 +0100   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Thu, 12 Apr 2018 11:23:09 +0100   Wed, 11 Apr 2018 15:38:58 +0100   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Thu, 12 Apr 2018 11:23:09 +0100   Wed, 11 Apr 2018 15:38:58 +0100   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:  10.0.2.15
  Hostname:    minikube

# Plus much more...
```

## Getting the status of the kube-system components...

Some Kubernetes components are handled as a DaemonSet (like the `kube-proxy`), others are Deployments and Services (`kube-dns`, `kube-dashboard`, etc.). 

All are in the namespace `kube-system`. Notice how Helm's `tiller` service is also in this namespace. When you don't declare this namespace, these components are excluded from the list returned (i.e. they are NOT returned by default).

```bash
kubectl get daemonSets --namespace=kube-system kube-proxy
NAME         DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
kube-proxy   1         1         1         1            1           <none>          19h
```

```bash
kubectl get deployments --namespace=kube-system kube-dns
NAME       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-dns   1         1         1            1           19h
```

```bash
kubectl get services --namespace=kube-system kube-dns
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP   19h
```

```bash
kubectl get deployments --namespace=kube-system kubernetes-dashboard
NAME                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kubernetes-dashboard   1         1         1            1           19h
```

```bash
kubectl get services --namespace=kube-system kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes-dashboard   NodePort   10.110.78.36   <none>        80:30000/TCP   19h
```

## Get the `kube-system` services...

```bash
kubectl get services --namespace=kube-system
NAME                   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
kube-dns               ClusterIP   10.96.0.10      <none>        53/UDP,53/TCP   20h
kubernetes-dashboard   NodePort    10.110.78.36    <none>        80:30000/TCP    20h
tiller-deploy          ClusterIP   10.103.58.125   <none>        44134/TCP       20h
```
## Get the `kube-system` deployments...

```bash
kubectl get deployments --namespace=kube-system
NAME                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
kube-dns               1         1         1            1           20h
kubernetes-dashboard   1         1         1            1           20h
tiller-deploy          1         1         1            1           20h
```

## Access the Kubernetes UI (Minikube)...

```bash
minikube dashboard
```

## Access the Kubernetes UI (non Minikube)...

The command `kubectl proxy` creates a proxy server or application-level gateway between localhost and the Kubernetes API Server. It also allows serving static content over specified HTTP path. All incoming data enters through one port and gets forwarded to the remote kubernetes API Server port, except for the path matching the static content path.

```bash
kubectl proxy
Starting to serve on 127.0.0.1:8001
```