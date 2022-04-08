# Azure Virtual Network

Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. VNet is similar to a traditional network that you'd operate in your own data center, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.

https://docs.microsoft.com/en-us/azure/virtual-network/

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
4. Go to the azue/vnet directory
    ```
    cd training/azure/vnet
    ```

## Task - 1
1. Create a virtual network (vnet) with subnet.
2. Add subnet to existing vnet

### Script name
`./create_vnet_cli.sh`

## Task - 2
1. Create two VMs with same subnet
2. Ping VM2 vnet IP from VM1

### Script name
`./create_vms_with_same_subnet.sh`

## Task - 3
1. Create VM3 with subnet 2
2. Ping VM3 vnet IP from VM1

### Script name
`./create_vms_with_diff_subnet.sh`

## Cleanup
Auto-generated `cleanup.sh` deletes the resource group.
