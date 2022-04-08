source create_vnet_cli.sh

VM_NAME_1=`whoami`-vm-1
VM_NAME_2=`whoami`-vm-2

debug "Create $VM_NAME_1 with $VNET_NAME_1_SUBNET_NAME_2"
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME_1 \
    --location $LOCATION \
    --size Standard_B2s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --ssh-key-values ~/.ssh/id_rsa.pub \
    --public-ip-sku Standard \
    --subnet $VNET_NAME_1_SUBNET_NAME_2 \
    --vnet-name $VNET_NAME_1

    VM_IP_1=`az vm list-ip-addresses \
            --name $VM_NAME_1 \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    debug "VM_IP: ${VM_IP_1}"
    echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP_1}" > ${VM_NAME_1}.ssh

debug "Create $VM_NAME_2 with $VNET_NAME_1_SUBNET_NAME_2"
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME_2 \
    --location $LOCATION \
    --size Standard_B2s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --ssh-key-values ~/.ssh/id_rsa.pub \
    --public-ip-sku Standard \
    --subnet $VNET_NAME_1_SUBNET_NAME_2 \
    --vnet-name $VNET_NAME_1

    VM_IP_2=`az vm list-ip-addresses \
            --name $VM_NAME_2 \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    debug "VM_IP: ${VM_IP_2}"
    echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP_2}" > ${VM_NAME_2}.ssh


