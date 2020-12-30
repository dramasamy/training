# Use the auth token to login; but the default RBAC won't allow the dahsboard to access resources

kubectl get secret `kubectl get sa -n kubernetes-dashboard kubernetes-dashboard -o jsonpath={.secrets[0].name}` -n kubernetes-dashboard -o jsonpath={.data.token} | base64 --decode
