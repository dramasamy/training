source create_vms_with_same_subnet.sh

VM_NAME_3=`whoami`-demo-vm-3

debug "Create $VM_NAME_3 with $SUBNET_NAME_2"
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME_3 \
    --location $LOCATION \
    --size Standard_B2s \
    --image UbuntuLTS \
    --admin-username azureuser \
    --ssh-key-values ~/.ssh/id_rsa.pub \
    --public-ip-sku Standard \
    --subnet $SUBNET_NAME_2 \
    --vnet-name $VNET_NAME

    VM_IP_3=`az vm list-ip-addresses \
            --name $VM_NAME_3 \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    debug "VM_IP: ${VM_IP_3}"
    echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP_3}" > ${VM_NAME_3}.ssh

