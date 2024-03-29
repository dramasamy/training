# Azure Arc - Cluster Connect, Logging and Monitoring demo

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
4. Go to the Azue/arc directory
    ```
    cd training/azure/arc
    ```
## Tasks
### Create and Arc enroll a VM and a kind cluster
1. Run `./arc_enroll_k8s_and_server.sh`
2. Login to Azure portal and look for `Server - Azure Arc` and `Kubernetes - Azure Arc` resources.
3. Delete the resoures - `cleanup.sh`

### Install AMA and Container insights
1. Run `install_ama_and_container_insights.sh`
2. Login to Azure portal and browse VM and container logs
3. Delete the resoures - `cleanup.sh`
#### Result of the script
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
Auto-generated `cleanup.sh` deletes the resource group.
