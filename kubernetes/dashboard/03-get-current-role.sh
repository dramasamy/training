kubectl get role -n kubernetes-dashboard `kubectl get rolebinding -n kubernetes-dashboard kubernetes-dashboard -o jsonpath={.roleRef.name}` -o yaml 
