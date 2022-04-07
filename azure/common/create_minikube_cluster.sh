FILE=args.sh
if [ -f "$FILE" ]; then
    source args.sh
else 
    source ../common/args.sh
fi

VM_NAME=`whoami`-minikube-vm
writevars "VM_NAME=${VM_NAME}"

debug "Variables" 
echo "VM_NAME=${VM_NAME}"

# ******************************************
#       CREATE K8S WORKLOAD CLUSTER
# ******************************************
# Create cloud init script
echo I2Nsb3VkLWNvbmZpZwp3cml0ZV9maWxlczoKLSBjb250ZW50OiB8CiAgICAjIEluc3RhbGwgZG9ja2VyIGFuZCBrdWJlY3RsCiAgICBzdWRvIGFwdC1nZXQgLXkgaW5zdGFsbCBjYS1jZXJ0aWZpY2F0ZXMgY3VybCBnbnVwZyBsc2ItcmVsZWFzZSBhcHQtdHJhbnNwb3J0LWh0dHBzIAogICAgY3VybCAtZnNTTCBodHRwczovL2Rvd25sb2FkLmRvY2tlci5jb20vbGludXgvdWJ1bnR1L2dwZyB8IHN1ZG8gZ3BnIC0tZGVhcm1vciAtbyAvdXNyL3NoYXJlL2tleXJpbmdzL2RvY2tlci1hcmNoaXZlLWtleXJpbmcuZ3BnIAogICAgZWNobyAiZGViIFthcmNoPSQoZHBrZyAtLXByaW50LWFyY2hpdGVjdHVyZSkgc2lnbmVkLWJ5PS91c3Ivc2hhcmUva2V5cmluZ3MvZG9ja2VyLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vZG93bmxvYWQuZG9ja2VyLmNvbS9saW51eC91YnVudHUgICQobHNiX3JlbGVhc2UgLWNzKSBzdGFibGUiIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvZG9ja2VyLmxpc3QgPiAvZGV2L251bGwgCiAgICBzdWRvIGN1cmwgLWZzU0xvIC91c3Ivc2hhcmUva2V5cmluZ3Mva3ViZXJuZXRlcy1hcmNoaXZlLWtleXJpbmcuZ3BnIGh0dHBzOi8vcGFja2FnZXMuY2xvdWQuZ29vZ2xlLmNvbS9hcHQvZG9jL2FwdC1rZXkuZ3BnIAogICAgZWNobyAiZGViIFtzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9rdWJlcm5ldGVzLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vYXB0Lmt1YmVybmV0ZXMuaW8vIGt1YmVybmV0ZXMteGVuaWFsIG1haW4iIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQva3ViZXJuZXRlcy5saXN0IAogICAgc3VkbyBhcHQtZ2V0IHVwZGF0ZSAKICAgIHN1ZG8gYXB0IGluc3RhbGwgLXkgdmltIHNzaCBuZXQtdG9vbHMgZG9ja2VyLWNlIGRvY2tlci1jZS1jbGkgY29udGFpbmVyZC5pbyBrdWJlY3RsIGNsb3VkLWd1ZXN0LXV0aWxzIG1ha2UgZ2NjIHZpcnR1YWxib3gKICAgIHN1ZG8gZ3JvdXBhZGQgZG9ja2VyIAogICAgc3VkbyB1c2VybW9kIC1hRyBkb2NrZXIgYXp1cmV1c2VyCgogICAgIyBJbnN0YWxsIEtpbmQgCiAgICBjdXJsIC1MbyAuL2tpbmQgaHR0cHM6Ly9raW5kLnNpZ3MuazhzLmlvL2RsL3YwLjExLjEva2luZC1saW51eC1hbWQ2NCAKICAgIGNobW9kICt4IC4va2luZCAKICAgIHN1ZG8gbXYgLi9raW5kIC91c3IvbG9jYWwvYmluL2tpbmQgCgogICAgIyBJbnN0YWxsIG1pbmlrdWJlCiAgICBjdXJsIC1MbyBtaW5pa3ViZSBodHRwczovL3N0b3JhZ2UuZ29vZ2xlYXBpcy5jb20vbWluaWt1YmUvcmVsZWFzZXMvbGF0ZXN0L21pbmlrdWJlLWxpbnV4LWFtZDY0CiAgICBjaG1vZCAreCBtaW5pa3ViZQogICAgc3VkbyBtdiAuL21pbmlrdWJlIC91c3IvbG9jYWwvYmluL21pbmlrdWJlCgogICAgIyBJbnN0YWxsIEF6dXJlLUNMSSAKICAgIGN1cmwgLXNMIGh0dHBzOi8vYWthLm1zL0luc3RhbGxBenVyZUNMSURlYiB8IHN1ZG8gYmFzaCAKICAgIGF6IGV4dGVuc2lvbiBhZGQgLS1uYW1lIGNvbm5lY3RlZGs4cwogICAgYXogZXh0ZW5zaW9uIGFkZCAtLW5hbWUgazhzLWV4dGVuc2lvbgogICAgYXogZXh0ZW5zaW9uIGFkZCAtLW5hbWUgY3VzdG9tbG9jYXRpb24KICAgIAogICAgIyBEb3dubG9hZCB0aGUgY29ubmVjdGVkIG1hY2hpbmUgaW5zdGFsbGF0aW9uIHBhY2thZ2UKICAgIHN1ZG8gcnVudXNlciAtdSBhenVyZXVzZXIgLS0gd2dldCBodHRwczovL2FrYS5tcy9hemNtYWdlbnQgLU8gL2hvbWUvYXp1cmV1c2VyL2luc3RhbGxfbGludXhfYXpjbWFnZW50LnNoCgogICAgIyBSZW1vdmUgQXp1cmUgc3BlY2lmaWMgYWdlbnRzIGFuZCBydWxlcyB0byB0cmVhdCB0aGlzIFZNIGxpa2UgYSByZW1vdGUgbWFjaGluZQogICAgY3VycmVudF9ob3N0bmFtZT0kKGhvc3RuYW1lKQogICAgc3VkbyBzZXJ2aWNlIHdhbGludXhhZ2VudCBzdG9wCiAgICBzdWRvIHdhYWdlbnQgLWRlcHJvdmlzaW9uIC1mb3JjZQogICAgc3VkbyBybSAtcmYgL3Zhci9saWIvd2FhZ2VudAogICAgc3VkbyBob3N0bmFtZWN0bCBzZXQtaG9zdG5hbWUgJGN1cnJlbnRfaG9zdG5hbWUKICAgIHN1ZG8gdWZ3IC0tZm9yY2UgZW5hYmxlCiAgICBzdWRvIHVmdyBkZW55IG91dCBmcm9tIGFueSB0byAxNjkuMjU0LjE2OS4yNTQKICAgIHN1ZG8gdWZ3IGRlZmF1bHQgYWxsb3cgaW5jb21pbmcKCiAgICAjIEluc3RhbGwgdGhlIGh5YnJpZCBhZ2VudAogICAgYmFzaCAvaG9tZS9henVyZXVzZXIvaW5zdGFsbF9saW51eF9hemNtYWdlbnQuc2gKICBwYXRoOiAvaG9tZS9henVyZXVzZXIvaW5zdGFsbC5zaAoKLSBjb250ZW50OiB8CiAgICBzdWRvIHJ1bnVzZXIgLXUgYXp1cmV1c2VyIC0tIG1pbmlrdWJlIHN0YXJ0CiAgcGF0aDogL2hvbWUvYXp1cmV1c2VyL21pbmlrdWJlY2x1c3Rlci5zaAoKLSBjb250ZW50OiB8CiAgICBzdWRvIHJ1bnVzZXIgLXUgYXp1cmV1c2VyIC0tIGtpbmQgY3JlYXRlIGNsdXN0ZXIKICAgIHN1ZG8gcnVudXNlciAtdSBhenVyZXVzZXIgLS0ga2luZCBleHBvcnQga3ViZWNvbmZpZwogIHBhdGg6IC9ob21lL2F6dXJldXNlci9raW5kY2x1c3Rlci5zaAoKLSBjb250ZW50OiB8CiAgICBTRUNSRVRfTkFNRT0kKGt1YmVjdGwgZ2V0IHNlcnZpY2VhY2NvdW50IGFkbWluLXVzZXIgLW8ganNvbnBhdGg9J3skLnNlY3JldHNbMF0ubmFtZX0nKQogICAgVE9LRU49JChrdWJlY3RsIGdldCBzZWNyZXQgJHtTRUNSRVRfTkFNRX0gLW8ganNvbnBhdGg9J3skLmRhdGEudG9rZW59JyB8IGJhc2U2NCAtZCB8IHNlZCAkJ3MvJC9cXFxuL2cnKQogICAgZWNobyAkVE9LRU4KICBwYXRoOiAvaG9tZS9henVyZXVzZXIvdG9rZW4uc2gKCi0gY29udGVudDogfAogICAgYWxpYXMga2dwPSdrdWJlY3RsIGdldCBwb2QgLW8gd2lkZScKICAgIGFsaWFzIGtncz0na3ViZWN0bCBnZXQgc3ZjIC1vIHdpZGUnCiAgICBhbGlhcyBrZ2Q9J2t1YmVjdGwgZ2V0IGRlcGxveSAtbyB3aWRlJwogICAgYWxpYXMga2djPSdrdWJlY3RsIGdldCBjbSAtQSAtbyB3aWRlJwogICAgYWxpYXMga2dwYT0na3ViZWN0bCBnZXQgcG9kIC1BIC1vIHdpZGUnCiAgICBhbGlhcyBrZ3NhPSdrdWJlY3RsIGdldCBzdmMgLUEgLW8gd2lkZScKICAgIGFsaWFzIGtnZGE9J2t1YmVjdGwgZ2V0IGRlcGxveSAtQSAtbyB3aWRlJwogICAgYWxpYXMga2djYT0na3ViZWN0bCBnZXQgY20gLUEgLW8gd2lkZScKICAgIGFsaWFzIGtnbj0na3ViZWN0bCBnZXQgbm9kZSAtbyB3aWRlJwogICAgYWxpYXMgJ2tjPWt1YmVjdGwnIAogIHBhdGg6IC9ob21lL2F6dXJldXNlci8uYmFzaHJjCiAgYXBwZW5kOiB0cnVlCgpydW5jbWQ6CiAgLSBzdWRvIGNob3duIGF6dXJldXNlcjphenVyZXVzZXIgL2hvbWUvYXp1cmV1c2VyCiAgLSBzdWRvIGNobW9kICt4IC9ob21lL2F6dXJldXNlci9pbnN0YWxsLnNoCiAgLSBzdWRvIGNobW9kICt4IC9ob21lL2F6dXJldXNlci90b2tlbi5zaAogIC0gc3VkbyBjaG1vZCAreCAvaG9tZS9henVyZXVzZXIvbWluaWt1YmVjbHVzdGVyLnNoCiAgLSAvaG9tZS9henVyZXVzZXIvaW5zdGFsbC5zaAogIC0gL2hvbWUvYXp1cmV1c2VyL21pbmlrdWJlY2x1c3Rlci5zaAogIC0gc3VkbyBjaG93biBhenVyZXVzZXI6YXp1cmV1c2VyIC1SIC9ob21lL2F6dXJldXNlcgo= | base64 -d > /tmp/cloud_init.yaml

    # ---------------------------------------------------- 
    debug "Create VM with cloud-int to install kubectl, kind, and azure-cli"
    # ---------------------------------------------------- 
    # Create Azure VM with cloud-inint
    az vm create \
        --resource-group $RESOURCE_GROUP \
        --name $VM_NAME \
        --location $LOCATION \
        --size Standard_D4_v3 \
        --image UbuntuLTS \
        --admin-username azureuser \
        --ssh-key-values ~/.ssh/id_rsa.pub \
        --custom-data /tmp/cloud_init.yaml \
        --public-ip-sku Standard

    VM_IP=`az vm list-ip-addresses \
            --name $VM_NAME \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    debug "VM_IP: ${VM_IP}"
    writevars "VM_IP=${VM_IP}"
    echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP}" > ${VM_NAME}.ssh


    debug "Wait for cloud-init to complete - 1000 seconds"
    sleep 1000
