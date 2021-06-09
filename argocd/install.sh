# Install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Update Service type to access UI
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

# Login to web UI
# Username: admnin
# Passwrod: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Login to argocd CLI <master:NodePort>
argocd login 172.16.94.130:31219

# Add git-repo to Argocd (Fork the following repo and use your private key)
argocd repo add git@github.com:dramasamy/training.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

# Create application
argocd app create nginx -f nginx/apps/nginx-app.yaml
