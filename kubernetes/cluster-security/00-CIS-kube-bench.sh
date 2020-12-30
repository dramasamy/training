# kube-bench is a Go application that checks whether Kubernetes is deployed securely by running
# the checks documented in the CIS Kubernetes Benchmark.

# https://github.com/aquasecurity/kube-bench#running-inside-a-container

# CIS Benchmark PDF: https://downloads.cisecurity.org

docker run --pid=host -v /etc:/etc:ro -v /var:/var:ro -t aquasec/kube-bench:latest master --version 1.19
