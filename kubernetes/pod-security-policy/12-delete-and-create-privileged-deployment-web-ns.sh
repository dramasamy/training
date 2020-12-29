# The policy name 'privileged' gets preference so the Pod will be created.
kubectl delete -f 10-create-privileged-deployment-web-ns.yaml
kubectl create -f 10-create-privileged-deployment-web-ns.yaml
