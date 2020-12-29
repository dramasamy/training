sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/
sudo sed -i "s/enable-admission-plugins=/enable-admission-plugins=PodSecurityPolicy,/g" /etc/kubernetes/manifests/kube-apiserver.yaml
