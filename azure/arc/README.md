# Azure Arc - Logging and Monitoring demo

The Azure Monitor agent (AMA) collects monitoring data from the guest operating system of virtual machines and delivers it to Azure Monitor. Container insights gives you performance visibility by collecting memory and processor metrics from controllers, nodes, and containers that are available in Kubernetes through the Metrics API. Container logs are also collected. After you enable monitoring from Kubernetes clusters, metrics and logs are automatically collected for you through a containerized version of the Log Analytics agent for Linux. Metrics are written to the metrics store and log data is written to the logs store associated with your Log Analytics workspace.

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
NAME | TYPE 
--- | --- 
ContainerInsights(whoami-law) | Solution
whoami-arc-remote-k8s | Kubernetes - Azure Arc
whoami-arc-vm | Virtual machine
whoami-arc-vm | Server - Azure Arc
whoami-arc-vm_OsDisk | Disk
whoami-arc-vmNSG | Network security group
whoami-arc-vmPublicIP | Public IP address
whoami-arc-vmVMNic | Network interface
whoami-arc-vmVNET | Virtual network
whoami-dcr | Data collection rule
whoami-law | Log Analytics workspace
dramasamy-arc-sp | Service Principle 

## Cleanup
`delete_kind_cluster.sh` deletes the resource group whoami-arc
