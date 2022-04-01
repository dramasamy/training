cat > kind-config.yaml <<EOF
# 7 node (6 workers) cluster config
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
- role: worker
- role: worker
- role: worker
EOF

kind create cluster --name k8s-playground --config kind-config.yaml
sleep 20

kubectl label node k8s-playground-worker topology.kubernetes.io/zone=1
kubectl label node k8s-playground-worker2 topology.kubernetes.io/zone=1
kubectl label node k8s-playground-worker3 topology.kubernetes.io/zone=2
kubectl label node k8s-playground-worker4 topology.kubernetes.io/zone=2
kubectl label node k8s-playground-worker5 topology.kubernetes.io/zone=3
kubectl label node k8s-playground-worker6 topology.kubernetes.io/zone=3

cat > cluster_vms.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    clustername: upfCluster
  name: clustervm
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 4
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      clustername: upfCluster
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        clustername: upfCluster
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: topology.kubernetes.io/zone
                operator: In
                values:
                - "1"
                - "3"
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: clustername
                  operator: In
                  values:
                  - upfCluster
              topologyKey: kubernetes.io/hostname
      containers:
      - command:
        - sleep
        - infinity
        image: busybox
        imagePullPolicy: IfNotPresent
        name: busybox
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
EOF

kubectl apply -f cluster_vms.yaml

kubectl get pods -n default -o wide
