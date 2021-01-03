
kubectl create secret generic my-secret2 --from-literal=key1=supersecret --from-literal=key2=topsecret
# secret/my-secret2 created

kubectl get secret my-secret2
# NAME         TYPE     DATA   AGE
# my-secret2   Opaque   2      12s
# [root@master1 bin]# kubectl get secret my-secret2 -o yaml
# apiVersion: v1
# data:
#   key1: c3VwZXJzZWNyZXQ=
#   key2: dG9wc2VjcmV0
# kind: Secret
# metadata:
#   creationTimestamp: "2021-01-03T20:22:32Z"
#   managedFields:
#   - apiVersion: v1
#     fieldsType: FieldsV1
#     fieldsV1:
#       f:data:
#         .: {}
#         f:key1: {}
#         f:key2: {}
#       f:type: {}
#     manager: kubectl-create
#     operation: Update
#     time: "2021-01-03T20:22:32Z"
#   name: my-secret2
#   namespace: default
#   resourceVersion: "149599"
#   selfLink: /api/v1/namespaces/default/secrets/my-secret2
#   uid: a3371a1c-e708-4660-982b-b5f426bc9d7c
# type: Opaque
# [root@master1 bin]# 

ETCDCTL_API=3 ./etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/my-secret2
# /registry/secrets/default/my-secret2
# k8s:enc:aescbc:v1:key1:\ufffd\u05bcUx\ufffdQS%\ufffd\ufffdQ\ufffdV\ufffd\ufffd\ufffdW^#\ufffdH\ufffd|8\ufffdL\ufffd\~\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffdj $dxG\ufffd\ufffd\ufffd\ufffdk\ufffdnd-n\ufffd1\ufffd"\ufffdWKc\ufffd\u05b5\ufffdR\ufffd\u035d[\ufffdu\ufffdp\ufffd\u012bR\ufffdA\ufffd\ufffd\u044ad\ufffd\ufffd?\ufffd%1\ufffd\ufffd\ufffd'\ufffd\ufffd\ufffd?-4\ufffd\ufffd~?P\ufffd\u6a94P@\ufffd\ufffd3\ufffd\ufffd^=\ufffd\ufffd;vU\ufffd2\ufffd+\ufffd\ufffd\ufffd7Tc\u05a1<\ufffd\ufffd\ufffdVJ\ufffd
#                                                                                                                                                                       \ufffdP\ufffd)\ufffd_qB\ufffd\ufffd\ufffd\ufffd`
#                                                                                                                                                                                     \ufffd\ufffdY\ufffd\ufffd\?\ufffd&\ufffd|\ufffd9\ufffd\ufffd\u0144v\ufffd\ufffdy\ufffdF\ufffd>h\ufffdH\u070ei\u03cd\ufffd\ufffd\ufffd\ufffd&,\ufffd\ufffd\ufffd^*\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd(\ufffdX\ufffd]\ufffd\ufffdr<\ufffd\ufffd\ufffd<
# L\ufffdGt	\ufffda>1\ufffd\ufffd\ufffd~\ufffd~\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\u05fd3\\ufffd
# [root@master1 bin]# 

# Encrypt all the secrets in the etcd store
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# get old secret
[root@master1 bin]# ETCDCTL_API=3 ./etcdctl --cert /etc/kubernetes/pki/apiserver-etcd-client.crt --key /etc/kubernetes/pki/apiserver-etcd-client.key --cacert /etc/kubernetes/pki/etcd/ca.crt get /registry/secrets/default/my-secret
# /registry/secrets/default/my-secret
# k8s:enc:aescbc:v1:key1:/\ufffd\ufffd1\ufffdI\ufffd>.p\ufffd\ufffd\u034a\ufffdX\ufffdu\ufffdz\ufffd\ufffd\ufffd\ufffd\ufffda\ufffd\u06cc\ufffdz\ufffd\ufffd\ufffd\ufffd4\u0234\ufffd
#                                                             \ufffd\ufffdf\ufffd\ufffd 
# \ufffdUZF#\u021c\ufffd\ufffd\ufffd%\ufffd\ufffd\ufffd\ufffd2\ufffd<-\ufffd.\ufffd\ufffd{/\ufffd\u38f5\ufffd6.`By	\ufffd\ufffdo\ufffdY=\ufffdtz\ufffd\ufffdvH\ufffd\ufffd\ufffd\ufffd\ufffd\ufffdL0\ufffd\7\ufffd/=\ufffdmt.\ufffd\ufffd\ufffdi\ufffd\ufffd'\ufffdq\ufffd\u05c4l\ufffd^k\ufffd\ufffd1:\ufffd\ufffd\ufffd8\ufffd\ufffd\ufffd$\ufffd\ufffd\ufffd\ufffd49\ufffdJZ\ufffdl3\ufffd%\ufffdy*\ufffd\ufffda\ufffd\ufffdb\ufffd\ufffd^Zs\ufffd\ufffdS\u0473?d\ufffd\ufffdh\ufffdD\ufffd\ufffd\ufffd\ufffdD,{=	XNzL\ufffdE\ufffd-\ufffdW\ufffdt\ufffd\u07ce\ufffd2&_\u06f4\ufffdC\ufffd=\ufffd\ufffdB\ufffdP\ufffdb\ufffd}z\ufffd\ufffd/\ufffd;\ufffd%[xSN\ufffd\ufffd\ufffd\ufffdpw\ufffdc\ufffd\ufffd\ufffd\ufffdgR\ufffd\ufffd\u6577s\ufffd\ufffd\ufffd"\u06eet\ufffdGoh5\ufffdWn\ufffd\ufffd\ufffd\ufffd \u0652k!X\ufffd]\ufffd\ufffd\ufffd\ufffdmA
#               \ufffd6\ufffd\ufffd`\ufffd6<\ufffd	%5\ufffd?%\ufffdR\ufffd\ufffd\ufffd\ufffd\ufffd9\ufffd\ufffd\ufffd5rU\ufffd\ufffd
# \ufffdGQ\ufffd\ufffdR\ufffd[|\ufffd;\ufffdS2f\ufffdmq
# \u03c3{H\ufffd-\ufffd  S           &\ufffd\ufffd\ufffd|%#\ufffd\ue176\ufffd\ufffdI8\ufffdD\ufffd\ufffd\ufffd\ufffd\ufffdm\ufffd\ufffdyhZ\ufffdFbT\ufffd<_G`\ufffdv~q\ufffd\ufffd\ufffdW5\ufffd\ufffd[\ufffd(Ecd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd"k\ufffd/\ufffd\ufffd\u010fV$\ufffd\ufffd\ufffd\ufffd\ufffdQ\ufffdY
# {\u0263,~\ufffd\ufffd\ufffd\ufffdj\ufffd\ufffdP
#          /{\ufffd\ufffd\ufffd4\ufffd\ufffd\ufffd\ufffdU.r[\u0597\ufffd\ufffd\ufffdr.
# \u0147\ufffdw\ufffd\ufffd\ufffd)\\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd1\ufffd\u0451\ufffd\ufffdI\ufffdg\ufffdx" \u02c3\ufffdD\ufffd\ufffd;\ufffdUyf\ufffd;\ufffd6\ufffd\ufffd<a<\ufffdkh\u0468
#                                                       \ufffd%\ufffd@+\ufffdRUT+\ufffd\ufffd4\ufffdp\ufffd\ufffd \ufffd\ufffd4,\ufffd6\ufffd\ufffd\ufffd\ufffdw\ufffdI\u034da\u07ec\ufffd\ufffdwB\u0614\ufffd
#                                                                                               \ufffd6JK\ufffd\ufffd;\ufffd\ufffdx\ufffdBUk\ufffd
# 
# /V
# \ufffdP\ufffda"$\ufffd\ufffd\ufffd10"\ufffd3sF\ufffd\\ufffd\ufffd.a,T\ufffd
# %\\ufffd\ufffd\ufffd\ufffdM4\ufffd\ufffd\ufffd5\ufffd\ufffd\ufffdJT:?}\ufffd\ufffdkng\ufffd7\ufffd@\ufffd\ufffdHN\ufffd\ufffd\ufffd\ufffd^\ufffd\ufffd\ufffdJs\ufffd\u0718%4\u01f8}\ufffd\ufffdl>\ufffd\ufffd4\ufffdv\ufffd\ufffd\ufffd\ufffd\ufffd\ufffd('\ufffdr\ufffd\ufffdz\ufffd6\ufffd1W\ufffdjg@\ufffd\ufffdP>d\ufffd\ufffd\u21c2\ufffd\ufffd\u02bf\ufffd\ufffd\ufffdp\ufffd\ufffd\u0215t\ufffd_z
# \ufffd\ufdad\ufffdO\ufffd\ufffd\ufffd\ufffd(\ufffd\ufffd|\ufffd\ufffd5\ufffdm\ufffd6\ufffd\ufffdI\ufffdm\ufffd\ufffdn\ufffd\ufffd\ufffd\ufffdQW\ufffds\ufffd\ufffd\ufffdd4\ufffd:\ufffd\ufffd\ufffdM\ufffdVs\ufffd\ufffdg,\ufffd\ufffd\ufffd|\ufffd\ufffd`\ufffd\ufffdsn\ufffd\ufffd\ufffd\ufffdJ\ufffd\ufffd\ufffd4w8\ufffd5\u071b\ufffd\ufffd\ufffdq\ufffd\ufffdm\ufffd\ufffd\ufffd\ufffd\ufffd\u0398\ufffd\ufffd\ufffd\u0445w\ufffd4\ufffd\ufffd8LK\ufffd\ufffd_\ufffd\ufffd_\ufffd\ufffd\ufffdz\ufffd:\ufffd\ufffdx\ufffd\ufffd\ufffd
#                                                                                                                                       <h\ufffd3\ufffdp\ufffd\ufffd\ufffdv\ufffd\ufffd\ufffde7\ufffdo\ufffd\ufffd\ufffd0\ufffd\ufffd\ufffd{t\ufffd\ufffd+\ufffd\ufffd\u04f0\ufffd\ufffd\ufffd\ufffdy$K\K\ufffd
#                                                                                                                                                                                    \uc3a9_\ufffd\ufffd\ufffd
# \ufffd\ufffd8G2Z\ufffd\ufffd\ufffd\ufffd!\ufffd!\ufffdX\ufffd,\ufffd@\ufffd\ufffd\ufffdG#\ufffdfU\ufffdQVz\ufffd\ufffd\ufffd\ufffdO\ufffd\ufffd\ufffd\ufffd\\ufffd\ufffd\ufffd\ufffd\ufffd\ufffdR\ufffdm\ufffd,\ufffd\ufffd\ufffdvscV\ufffd\ufffde\u0163\u07fc\ufffd\ufffd\ufffd\ufffd\ufffd\ufffdRu\ufffd\ufffd\ufffd
# $\ufffd-
# [root@master1 bin]# 
# 
