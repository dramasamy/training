# https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/

cat << EOF > /etc/kubernetes/policy/imagepolicyconfig.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/policy/kubeconfig
      # time in s to cache approval
      allowTTL: 50
      # time in s to cache denial
      denyTTL: 50
      # time in ms to wait between retries
      retryBackoff: 500
      # determines behavior if the webhook backend fails; true -> allow pod after timeout; false -> fail pod creation
      defaultAllow: true
EOF


cat << EOF> /etc/kubernetes/policy/kubeconfig
apiVersion: v1
kind: Config

clusters:
- name: name-of-remote-imagepolicy-service
  cluster:
    certificate-authority: /etc/kubernetes/policy/ca.crt
    server: https://images.example.com/policy

contexts:
- context:
    cluster: name-of-remote-imagepolicy-service
    user: name-of-api-server
  name: image-checker
current-context: image-checker
preferences: {}

# users refers to the API server's webhook configuration.
users:
- name: name-of-api-server
  user:
    client-certificate: /etc/kubernetes/policy/server.crt
    client-key: /etc/kubernetes/policy/server.key
EOF

cp ca.crt ca.key server.crt server.key /etc/kubernetes/policy

#Add the following in kube-apiserver.yaml
# - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook
# - --admission-control-config-file=/etc/kubernetes/policy/imagepolicyconfig.yaml

# Note: Also add volume and volume mount for /etc/kubernetes/policy/ in api server yaml
