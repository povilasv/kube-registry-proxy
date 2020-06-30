# kube-registry-proxy
Kube-registry-proxy which fixes timeout issue in kubernetes registry proxy.

## Configuration
This docker image is configurable with following environment variables:
- ```REGISTRY_HOST```: Cluster IP of kubernetes-registry service
- ```REGISTRY_PORT``` (**5000**): Internal port of kubernetes-registry service
- ```REGISTRY_CA```: Use if a secure image is used within the Dockerfile and the ```ca.crt``` is mount as a secret
- ```FORWARD_PORT``` (**5000**): The internal haproxy port that shall match ```containerPort```

## Example
Example of configuring proxy:
```
kubectl get svc kube-registry
NAME            CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
kube-registry   10.254.255.196   <none>        5000/TCP   2d
```
We can see that cluster ip is ```10.254.255.196``` & ```REGISTRY_PORT``` is ```5000```.  
And the FQDN is ```kube-registry.default.svc.cluster.local``` where ```default``` is the namespace.  

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
    # Use an appropriate image build
    image: tpve/kube-registry-proxy:0.3.3
    resources:
      limits:
        cpu: 100m
        memory: 50Mi
    env:
    - name: REGISTRY_HOST
    # Use a service IP
      value: 10.254.255.196
    # Or use a service FQDN
    # value: kube-registry.NAMESPACE.svc.cluster.local

    # Service/pod port
    - name: REGISTRY_PORT
      value: "5000"

    # Any arbitrary port on the container that will get its traffic
    # forwarded to the registry
    - name: FORWARD_PORT
      value: "5000"

    # Use this environment variable
    #- name: REGISTRY_CA
    #  value: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    ports:
    - name: registry
      # Shall match FORWARD_PORT
      containerPort: 5000

      # Exposed port that shall be required to present in the image tags
      hostPort: 5000
```
