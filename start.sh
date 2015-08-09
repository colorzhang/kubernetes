kube-apiserver --insecure-bind-address=0.0.0.0 --insecure-port=8080 --service-cluster-ip-range=10.0.0.0/16 --etcd_servers=http://localhost:4001 --admission_control=NamespaceLifecycle,LimitRanger,ResourceQuota &

kube-controller-manager --master=http://localhost:8080 &

kube-scheduler --master=http://localhost:8080 &

kube-proxy --master=http://localhost:8080 &

kubelet --api_servers=http://localhost:8080 &


