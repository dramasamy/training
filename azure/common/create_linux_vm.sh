FILE=args.sh
if [ -f "$FILE" ]; then
    source args.sh
else 
    source ../common/args.sh
fi

VM_NAME=`whoami`-azcli-vm
writevars "VM_NAME=${VM_NAME}"

echo "VM_NAME=${VM_NAME}"

debug "Install extensions"
az extension add --name monitor-control-service
az extension add --name connectedmachine 
az extension add --name k8s-extension
az extension add --name customlocation

echo I2Nsb3VkLWNvbmZpZwp3cml0ZV9maWxlczoKLSBjb250ZW50OiB8CiAgICAjIEluc3RhbGwgZG9ja2VyIGFuZCBrdWJlY3RsCiAgICBzdWRvIGFwdC1nZXQgLXkgaW5zdGFsbCBjYS1jZXJ0aWZpY2F0ZXMgY3VybCBnbnVwZyBsc2ItcmVsZWFzZSBhcHQtdHJhbnNwb3J0LWh0dHBzIAogICAgY3VybCAtZnNTTCBodHRwczovL2Rvd25sb2FkLmRvY2tlci5jb20vbGludXgvdWJ1bnR1L2dwZyB8IHN1ZG8gZ3BnIC0tZGVhcm1vciAtbyAvdXNyL3NoYXJlL2tleXJpbmdzL2RvY2tlci1hcmNoaXZlLWtleXJpbmcuZ3BnIAogICAgZWNobyAiZGViIFthcmNoPSQoZHBrZyAtLXByaW50LWFyY2hpdGVjdHVyZSkgc2lnbmVkLWJ5PS91c3Ivc2hhcmUva2V5cmluZ3MvZG9ja2VyLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vZG93bmxvYWQuZG9ja2VyLmNvbS9saW51eC91YnVudHUgICQobHNiX3JlbGVhc2UgLWNzKSBzdGFibGUiIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvZG9ja2VyLmxpc3QgPiAvZGV2L251bGwgCiAgICBzdWRvIGN1cmwgLWZzU0xvIC91c3Ivc2hhcmUva2V5cmluZ3Mva3ViZXJuZXRlcy1hcmNoaXZlLWtleXJpbmcuZ3BnIGh0dHBzOi8vcGFja2FnZXMuY2xvdWQuZ29vZ2xlLmNvbS9hcHQvZG9jL2FwdC1rZXkuZ3BnIAogICAgZWNobyAiZGViIFtzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9rdWJlcm5ldGVzLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vYXB0Lmt1YmVybmV0ZXMuaW8vIGt1YmVybmV0ZXMteGVuaWFsIG1haW4iIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQva3ViZXJuZXRlcy5saXN0IAogICAgc3VkbyBhcHQtZ2V0IHVwZGF0ZSAKICAgIHN1ZG8gYXB0IGluc3RhbGwgLXkgdmltIHNzaCBuZXQtdG9vbHMgZG9ja2VyLWNlIGRvY2tlci1jZS1jbGkgY29udGFpbmVyZC5pbyBrdWJlY3RsIGNsb3VkLWd1ZXN0LXV0aWxzIG1ha2UgZ2NjCiAgICBzdWRvIGdyb3VwYWRkIGRvY2tlciAKICAgIHN1ZG8gdXNlcm1vZCAtYUcgZG9ja2VyIGF6dXJldXNlcgoKICAgICMgSW5zdGFsbCBLaW5kIAogICAgY3VybCAtTG8gLi9raW5kIGh0dHBzOi8va2luZC5zaWdzLms4cy5pby9kbC92MC4xMS4xL2tpbmQtbGludXgtYW1kNjQgCiAgICBjaG1vZCAreCAuL2tpbmQgCiAgICBzdWRvIG12IC4va2luZCAvdXNyL2xvY2FsL2Jpbi9raW5kIAoKICAgICMgSW5zdGFsbCBBenVyZS1DTEkgCiAgICBjdXJsIC1zTCBodHRwczovL2FrYS5tcy9JbnN0YWxsQXp1cmVDTElEZWIgfCBzdWRvIGJhc2ggCiAgICBheiBleHRlbnNpb24gYWRkIC0tbmFtZSBjb25uZWN0ZWRrOHMKICAgIGF6IGV4dGVuc2lvbiBhZGQgLS1uYW1lIGs4cy1leHRlbnNpb24KICAgIGF6IGV4dGVuc2lvbiBhZGQgLS1uYW1lIGN1c3RvbWxvY2F0aW9uCgogIHBhdGg6IC9ob21lL2F6dXJldXNlci9pbnN0YWxsLnNoCgotIGNvbnRlbnQ6IHwKICAgIGFsaWFzIGtncD0na3ViZWN0bCBnZXQgcG9kIC1vIHdpZGUnCiAgICBhbGlhcyBrZ3M9J2t1YmVjdGwgZ2V0IHN2YyAtbyB3aWRlJwogICAgYWxpYXMga2dkPSdrdWJlY3RsIGdldCBkZXBsb3kgLW8gd2lkZScKICAgIGFsaWFzIGtnYz0na3ViZWN0bCBnZXQgY20gLUEgLW8gd2lkZScKICAgIGFsaWFzIGtncGE9J2t1YmVjdGwgZ2V0IHBvZCAtQSAtbyB3aWRlJwogICAgYWxpYXMga2dzYT0na3ViZWN0bCBnZXQgc3ZjIC1BIC1vIHdpZGUnCiAgICBhbGlhcyBrZ2RhPSdrdWJlY3RsIGdldCBkZXBsb3kgLUEgLW8gd2lkZScKICAgIGFsaWFzIGtnY2E9J2t1YmVjdGwgZ2V0IGNtIC1BIC1vIHdpZGUnCiAgICBhbGlhcyBrZ249J2t1YmVjdGwgZ2V0IG5vZGUgLW8gd2lkZScKICAgIGFsaWFzICdrYz1rdWJlY3RsJyAKICBwYXRoOiAvaG9tZS9henVyZXVzZXIvLmJhc2hyYwogIGFwcGVuZDogdHJ1ZQoKcnVuY21kOgogIC0gc3VkbyBjaG93biBhenVyZXVzZXI6YXp1cmV1c2VyIC9ob21lL2F6dXJldXNlcgogIC0gc3VkbyBjaG1vZCAreCAvaG9tZS9henVyZXVzZXIvaW5zdGFsbC5zaAogIC0gL2hvbWUvYXp1cmV1c2VyL2luc3RhbGwuc2gKICAtIHN1ZG8gY2hvd24gYXp1cmV1c2VyOmF6dXJldXNlciAtUiAvaG9tZS9henVyZXVzZXI | base64 -d > /tmp/cloud-init.yaml

# ---------------------------------------------------- 
debug "Create VM with cloud-int to install kubectl, kind, and azure-cli"
# ---------------------------------------------------- 
# Create Azure VM with cloud-inint
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --location $LOCATION \
    --size Standard_B1ms \
    --image UbuntuLTS \
    --admin-username azureuser \
    --ssh-key-values ~/.ssh/id_rsa.pub \
    --custom-data /tmp/cloud-init.yaml \
    --public-ip-sku Standard

VM_IP=`az vm list-ip-addresses \
        --name $VM_NAME \
        --resource-group $RESOURCE_GROUP \
        --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
        -o tsv`

debug "VM_IP: ${VM_IP}"
writevars "VM_IP=${VM_IP}"
echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP}" > ${VM_NAME}.ssh

debug "Wait for cloud-init to complete - 30 seconds"
sleep 30
