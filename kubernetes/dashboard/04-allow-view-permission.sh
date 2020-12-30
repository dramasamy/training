# Allow view permission and browse the dashboard again
kubectl create clusterrolebinding view-dashboard --clusterrole=view --user=system:serviceaccount:kubernetes-dashboard:kubernetes-dashboard
