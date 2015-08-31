# kubernetes

Dockerize hybris components and orchestrate with Kubernetes

https://wiki.hybris.com/display/~winston.zhang@hybris.com/Dockerize+hybris+and+orchestrate+with+Kubernetes

#Motivation

containerize hybris components

auto-scale

auto-heal

auto provision on bare metal and cloud providers

resource orchestration

immutable infrastructure


#Preparation

    software
    hybris 5.6
    solr 5.2.1
    zookeeper 3.4.6
    mysql 5.6.26
    docker 1.7.1
    gentoo linux latest
    etcd 2.1.1
    kubernetes 1.0.1

    environment

#Dockerize hybris
https://github.com/colorzhang/docker

    Dockerize
    based on Open JDK 8
    Optimize
    minimize steps
    non-root user
    ports

    Parameterise
    TODO

    Final Dockfile
    Further improvement

#Verify with docker command
##build image
    docker build -t winston/hybris56 .
##run
    docker run -it --name=hybris -p 9001:9001 -p 9002:9002 -p 8000:8000 winston/hybris56
    
#Kubernetes up & running

##build
```bash
git clone https://github.com/kubernetes/kubernetes
cd kubernetes
make
cp _output/local/bin/linux/amd64/kube* /usr/bin
```

##run kubernetes
```bash
kube-apiserver --allow-privileged --insecure-bind-address=0.0.0.0 --insecure-port=8080 --service-cluster-ip-range=10.0.0.0/16 --etcd_servers=http://localhost:4001 --admission_control=NamespaceLifecycle,LimitRanger,ResourceQuota >/var/log/kube/kube-apiserver.log 2>&1 &

kube-controller-manager --master=http://localhost:8080 >/var/log/kube/kube-controller-manager.log 2>&1 &

kube-scheduler --master=http://localhost:8080 >/var/log/kube/kube-scheduler.log 2>&1 &

kube-proxy --master=http://localhost:8080 --legacy-userspace-proxy=false --v=1 >/var/log/kube/kube-proxy.log 2>&1 &

kubelet --allow-privileged --api_servers=http://localhost:8080 --v=1 >/var/log/kube/kubelet.log 2>&1 &
```

##run hybris components
```bash
kubernetes create -f zk-service.yaml
kubernetes create -f solr-service.yaml
kubernetes create -f mysql-service.yaml
kubernetes create -f hybris56-service.yaml

kubernetes create -f zk-rc.yaml
kubernetes create -f solr-rc.yaml
kubernetes create -f mysql-rc.yaml
kubernetes create -f hybris56-rc.yaml
```

##Verify
```bash
gentoo ~ # kubectl get po
NAME                         READY     STATUS    RESTARTS   AGE
hybris56-controller-9p5su    1/1       Running   0          3h
mysql-controller-o9wof       1/1       Running   0          8h
solrcloud-controller-sklrt   1/1       Running   0          8h
solrcloud-controller-tshs7   1/1       Running   0          8h
zk-controller-yt97k          1/1       Running   0          8h
gentoo ~ # kubectl get svc
NAME               CLUSTER_IP     EXTERNAL_IP   PORT(S)                      SELECTOR        AGE
hybris56-service   10.0.159.218   <none>        9001/TCP,9002/TCP,8000/TCP   app=hybris56    23d
kubernetes         10.0.0.1       <none>        443/TCP                      <none>          29d
mysql-service      10.0.199.144   <none>        3306/TCP                     app=mysql       2d
solr-service       10.0.162.73    <none>        8983/TCP                     app=solrcloud   2d
zk-service         10.0.108.253   <none>        2181/TCP                     app=zookeeper   20d
gentoo ~ # kubectl get rc
CONTROLLER             CONTAINER(S)   IMAGE(S)             SELECTOR        REPLICAS   AGE
hybris56-controller    hybris56       winston/hybris:5.6   app=hybris56    1          3h
mysql-controller       mysql          mysql:5.6            app=mysql       1          8h
solrcloud-controller   solrcloud      winston/solr:5.2.1   app=solrcloud   2          8h
zk-controller          zookeeper      apache/zookeeper     app=zookeeper   1          8h
gentoo ~ # kubectl get ep
NAME               ENDPOINTS                                               AGE
hybris56-service   172.17.0.112:9002,172.17.0.112:9001,172.17.0.112:8000   23d
kubernetes         10.0.2.15:6443                                          29d
mysql-service      172.17.0.43:3306                                        2d
solr-service       172.17.0.66:8983,172.17.0.67:8983                       2d
zk-service         172.17.0.62:2181                                        20d
```

#Scale in & out
```bash
kubectl scale --replicas=4 replicationcontrollers solrcloud-controller
```

#Orchestrate more components

    dockerize solr/zookeeper
    dockerize mysql
    dockerize nginx

#Further improvements

    automate with Ansible
    multi-nodes kubernetes cluster
    monitoring
    security
    overlay network

Happy containerizing!

Winston Zhang (colorzhang@gmail.com)

August 2015
