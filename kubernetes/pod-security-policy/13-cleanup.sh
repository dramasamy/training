kubectl delete -f 05-create-deployment-web-ns.yaml
kubectl delete -f 10-create-privileged-deployment-web-ns.yaml
kubectl delete -f 11-allow-psp-access-to-web-ns.yaml
kubectl delete -f 09-allow-restricted-psp-access-to-web-ns.yaml
kubectl delete -f 04-create-web-namespace.yaml
kubectl delete -f 03-allow-psp-access-to-kube-system.yaml
kubectl delete -f 07-create-restricted-psp.yaml
kubectl delete -f 02-create-privileged-psp.yaml
sudo sed -i "s/enable-admission-plugins=PodSecurityPolicy,/enable-admission-plugins=/g" /etc/kubernetes/manifests/kube-apiserver.yaml
