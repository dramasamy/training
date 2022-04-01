# Azure Logging and Monitoring demo

The Azure Monitor agent (AMA) collects monitoring data from the guest operating system of Azure virtual machines and delivers it to Azure Monitor. Container insights gives you performance visibility by collecting memory and processor metrics from controllers, nodes, and containers that are available in Kubernetes through the Metrics API. Container logs are also collected. After you enable monitoring from Kubernetes clusters, metrics and logs are automatically collected for you through a containerized version of the Log Analytics agent for Linux. Metrics are written to the metrics store and log data is written to the logs store associated with your Log Analytics workspace.

`create_and_enroll_kind_cluster.sh` script creates a resource group (whoami-arc) in your Azure subscription to create the required resources for this demo.

## Prerequisites
1. Clone this git repo
    ```
    git clone https://github.com/dramasamy/training.git
    ```
2. Login to your Azure account
    ```
    az login
    ```
3. Set a subscription to be the current active subscription.
    ```
    az account set --subscription <subscription-id>
    ```
## Run the script
1. Go to the Azue/arc directory
    ```
    cd training/azure/arc
    ```
2. Invoke the shell script
    ```
    ./create_and_enroll_kind_cluster.sh
    ```
## Result of the script
1. Service principal for arc enrollment
2. Log analytics workspace
3. Data collection rule
4. A Ubuntu VM to start Kind cluster (Standard_B2s)
5. .ssh file to conenct to the VM
6. Arc connected server
7. AMA installation in the connected server
8. Asscoiate the Data Collection Rule with the VM
9. Arc enroll the Kind cluster
10. Install container insights

## Cleanup
`delete_kind_cluster.sh` deletes the resource group whoami-arc
