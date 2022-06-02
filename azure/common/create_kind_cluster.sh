FILE=args.sh
if [ -f "$FILE" ]; then
    source args.sh
else 
    source ../common/args.sh
fi

VM_NAME=`whoami`-arc-vm
writevars "VM_NAME=${VM_NAME}"

debug "Variables" 
echo "VM_NAME=${VM_NAME}"

# ******************************************
#       CREATE K8S WORKLOAD CLUSTER
# ******************************************
# Create cloud init script
echo I2Nsb3VkLWNvbmZpZwp3cml0ZV9maWxlczoKLSBjb250ZW50OiB8CiAgICAjIEluc3RhbGwgZG9ja2VyIGFuZCBrdWJlY3RsCiAgICBzdWRvIGFwdC1nZXQgLXkgaW5zdGFsbCBjYS1jZXJ0aWZpY2F0ZXMgY3VybCBnbnVwZyBsc2ItcmVsZWFzZSBhcHQtdHJhbnNwb3J0LWh0dHBzIAogICAgY3VybCAtZnNTTCBodHRwczovL2Rvd25sb2FkLmRvY2tlci5jb20vbGludXgvdWJ1bnR1L2dwZyB8IHN1ZG8gZ3BnIC0tZGVhcm1vciAtbyAvdXNyL3NoYXJlL2tleXJpbmdzL2RvY2tlci1hcmNoaXZlLWtleXJpbmcuZ3BnIAogICAgZWNobyAiZGViIFthcmNoPSQoZHBrZyAtLXByaW50LWFyY2hpdGVjdHVyZSkgc2lnbmVkLWJ5PS91c3Ivc2hhcmUva2V5cmluZ3MvZG9ja2VyLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vZG93bmxvYWQuZG9ja2VyLmNvbS9saW51eC91YnVudHUgICQobHNiX3JlbGVhc2UgLWNzKSBzdGFibGUiIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvZG9ja2VyLmxpc3QgPiAvZGV2L251bGwgCiAgICBzdWRvIGN1cmwgLWZzU0xvIC91c3Ivc2hhcmUva2V5cmluZ3Mva3ViZXJuZXRlcy1hcmNoaXZlLWtleXJpbmcuZ3BnIGh0dHBzOi8vcGFja2FnZXMuY2xvdWQuZ29vZ2xlLmNvbS9hcHQvZG9jL2FwdC1rZXkuZ3BnIAogICAgZWNobyAiZGViIFtzaWduZWQtYnk9L3Vzci9zaGFyZS9rZXlyaW5ncy9rdWJlcm5ldGVzLWFyY2hpdmUta2V5cmluZy5ncGddIGh0dHBzOi8vYXB0Lmt1YmVybmV0ZXMuaW8vIGt1YmVybmV0ZXMteGVuaWFsIG1haW4iIHwgc3VkbyB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQva3ViZXJuZXRlcy5saXN0IAogICAgc3VkbyBhcHQtZ2V0IHVwZGF0ZSAKICAgIHN1ZG8gYXB0IGluc3RhbGwgLXkgdmltIHNzaCBuZXQtdG9vbHMgZG9ja2VyLWNlIGRvY2tlci1jZS1jbGkgY29udGFpbmVyZC5pbyBrdWJlY3RsIGNsb3VkLWd1ZXN0LXV0aWxzIG1ha2UgZ2NjCiAgICBzdWRvIGdyb3VwYWRkIGRvY2tlciAKICAgIHN1ZG8gdXNlcm1vZCAtYUcgZG9ja2VyIGF6dXJldXNlcgoKICAgICMgSW5zdGFsbCBLaW5kIAogICAgY3VybCAtTG8gLi9raW5kIGh0dHBzOi8va2luZC5zaWdzLms4cy5pby9kbC92MC4xMS4xL2tpbmQtbGludXgtYW1kNjQgCiAgICBjaG1vZCAreCAuL2tpbmQgCiAgICBzdWRvIG12IC4va2luZCAvdXNyL2xvY2FsL2Jpbi9raW5kIAoKICAgICMgSW5zdGFsbCBBenVyZS1DTEkgCiAgICBjdXJsIC1zTCBodHRwczovL2FrYS5tcy9JbnN0YWxsQXp1cmVDTElEZWIgfCBzdWRvIGJhc2ggCiAgICBheiBleHRlbnNpb24gYWRkIC0tbmFtZSBjb25uZWN0ZWRrOHMKICAgIGF6IGV4dGVuc2lvbiBhZGQgLS1uYW1lIGs4cy1leHRlbnNpb24KICAgIGF6IGV4dGVuc2lvbiBhZGQgLS1uYW1lIGN1c3RvbWxvY2F0aW9uCiAgICAKICAgICMgRG93bmxvYWQgdGhlIGNvbm5lY3RlZCBtYWNoaW5lIGluc3RhbGxhdGlvbiBwYWNrYWdlCiAgICBzdWRvIHJ1bnVzZXIgLXUgYXp1cmV1c2VyIC0tIHdnZXQgaHR0cHM6Ly9ha2EubXMvYXpjbWFnZW50IC1PIC9ob21lL2F6dXJldXNlci9pbnN0YWxsX2xpbnV4X2F6Y21hZ2VudC5zaAoKICAgICMgUmVtb3ZlIEF6dXJlIHNwZWNpZmljIGFnZW50cyBhbmQgcnVsZXMgdG8gdHJlYXQgdGhpcyBWTSBsaWtlIGEgcmVtb3RlIG1hY2hpbmUKICAgIGN1cnJlbnRfaG9zdG5hbWU9JChob3N0bmFtZSkKICAgIHN1ZG8gc2VydmljZSB3YWxpbnV4YWdlbnQgc3RvcAogICAgc3VkbyB3YWFnZW50IC1kZXByb3Zpc2lvbiAtZm9yY2UKICAgIHN1ZG8gcm0gLXJmIC92YXIvbGliL3dhYWdlbnQKICAgIHN1ZG8gaG9zdG5hbWVjdGwgc2V0LWhvc3RuYW1lICRjdXJyZW50X2hvc3RuYW1lCiAgICBzdWRvIHVmdyAtLWZvcmNlIGVuYWJsZQogICAgc3VkbyB1ZncgZGVueSBvdXQgZnJvbSBhbnkgdG8gMTY5LjI1NC4xNjkuMjU0CiAgICBzdWRvIHVmdyBkZWZhdWx0IGFsbG93IGluY29taW5nCgogICAgIyBJbnN0YWxsIHRoZSBoeWJyaWQgYWdlbnQKICAgIGJhc2ggL2hvbWUvYXp1cmV1c2VyL2luc3RhbGxfbGludXhfYXpjbWFnZW50LnNoCiAgcGF0aDogL2hvbWUvYXp1cmV1c2VyL2luc3RhbGwuc2gKCi0gY29udGVudDogfAogICAgc3VkbyBydW51c2VyIC11IGF6dXJldXNlciAtLSBraW5kIGNyZWF0ZSBjbHVzdGVyCiAgICBzdWRvIHJ1bnVzZXIgLXUgYXp1cmV1c2VyIC0tIGtpbmQgZXhwb3J0IGt1YmVjb25maWcKICBwYXRoOiAvaG9tZS9henVyZXVzZXIva2luZGNsdXN0ZXIuc2gKCi0gY29udGVudDogfAogICAgU0VDUkVUX05BTUU9JChrdWJlY3RsIGdldCBzZXJ2aWNlYWNjb3VudCBhZG1pbi11c2VyIC1vIGpzb25wYXRoPSd7JC5zZWNyZXRzWzBdLm5hbWV9JykKICAgIFRPS0VOPSQoa3ViZWN0bCBnZXQgc2VjcmV0ICR7U0VDUkVUX05BTUV9IC1vIGpzb25wYXRoPSd7JC5kYXRhLnRva2VufScgfCBiYXNlNjQgLWQgfCBzZWQgJCdzLyQvXFxcbi9nJykKICAgIGVjaG8gJFRPS0VOCiAgcGF0aDogL2hvbWUvYXp1cmV1c2VyL3Rva2VuLnNoCgotIGNvbnRlbnQ6IHwKICAgIGFsaWFzIGtncD0na3ViZWN0bCBnZXQgcG9kIC1vIHdpZGUnCiAgICBhbGlhcyBrZ3M9J2t1YmVjdGwgZ2V0IHN2YyAtbyB3aWRlJwogICAgYWxpYXMga2dkPSdrdWJlY3RsIGdldCBkZXBsb3kgLW8gd2lkZScKICAgIGFsaWFzIGtnYz0na3ViZWN0bCBnZXQgY20gLUEgLW8gd2lkZScKICAgIGFsaWFzIGtncGE9J2t1YmVjdGwgZ2V0IHBvZCAtQSAtbyB3aWRlJwogICAgYWxpYXMga2dzYT0na3ViZWN0bCBnZXQgc3ZjIC1BIC1vIHdpZGUnCiAgICBhbGlhcyBrZ2RhPSdrdWJlY3RsIGdldCBkZXBsb3kgLUEgLW8gd2lkZScKICAgIGFsaWFzIGtnY2E9J2t1YmVjdGwgZ2V0IGNtIC1BIC1vIHdpZGUnCiAgICBhbGlhcyBrZ249J2t1YmVjdGwgZ2V0IG5vZGUgLW8gd2lkZScKICAgIGFsaWFzICdrYz1rdWJlY3RsJyAKICBwYXRoOiAvaG9tZS9henVyZXVzZXIvLmJhc2hyYwogIGFwcGVuZDogdHJ1ZQoKcnVuY21kOgogIC0gc3VkbyBjaG93biBhenVyZXVzZXI6YXp1cmV1c2VyIC9ob21lL2F6dXJldXNlcgogIC0gc3VkbyBjaG1vZCAreCAvaG9tZS9henVyZXVzZXIvaW5zdGFsbC5zaAogIC0gc3VkbyBjaG1vZCAreCAvaG9tZS9henVyZXVzZXIvdG9rZW4uc2gKICAtIHN1ZG8gY2htb2QgK3ggL2hvbWUvYXp1cmV1c2VyL2tpbmRjbHVzdGVyLnNoCiAgLSAvaG9tZS9henVyZXVzZXIvaW5zdGFsbC5zaAogIC0gL2hvbWUvYXp1cmV1c2VyL2tpbmRjbHVzdGVyLnNoCiAgLSBzdWRvIGNob3duIGF6dXJldXNlcjphenVyZXVzZXIgLVIgL2hvbWUvYXp1cmV1c2Vy | base64 -d > /tmp/cloud_init.yaml

FILE=~/.ssh/id_rsa.pub
if [ -f "$FILE" ]; then
    echo "Found SSH Ket file to use"
else
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi
    # ---------------------------------------------------- 
    debug "Create VM with cloud-int to install kubectl, kind, and azure-cli"
    # ---------------------------------------------------- 
    # Create Azure VM with cloud-inint
    az vm create \
        --resource-group $RESOURCE_GROUP \
        --name $VM_NAME \
        --location $LOCATION \
        --size Standard_B2s \
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
    chmod +x ${VM_NAME}.ssh

    debug "Wait for cloud-init to complete - 200 seconds"
    sleep 200

