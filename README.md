# kube-registry-proxy
Kube-registry-proxy which fixes timeout issue in kubernetes registry proxy.

This docker image is configurable with following environment variables: IP, PORT, FWDPORT.

IP is a cluster ip of kubernetes-registry service. By default PORT & FWDPORT is 5000.

Example of configuring proxy:
```
kubectl get svc kube-registry
NAME            CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kube-registry   10.254.255.196   <none>        5000/TCP   2d
```
We can see that cluster ip is 10.254.255.196 & FWDPORT is 5000.

Kubernetes pod configuration looks like:
```
apiVersion: v1
kind: Pod
metadata:
  name: kube-registry-proxy
  namespace: kube-system
spec:
  containers:
  - name: kube-registry-proxy
    image: tpve/kube-registry-proxy:0.3.3
    resources:
      limits:
        cpu: 100m
        memory: 50Mi
    env:
    - name: IP
      value: 10.254.255.196
    - name: PORT
      value: "5000"
    - name: FWDPORT
      value: "5000"
    ports:
    - name: registry
      containerPort: 5000
      hostPort: 5000
```
