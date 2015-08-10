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
