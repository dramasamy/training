if [ "$1" == "minikube" ]; then
    echo "Using minikube"
    source ../common/create_minikube_cluster.sh
else
    echo "Using kind"
    source ../common/create_kind_cluster.sh
fi

K8S_CLUSTER_NAME=`whoami`-arc-remote-k8s
SERVICE_PRINCIPLE_NAME=`whoami`-arc-sp
ARC_CONNECTED_SERVER_NAME=$VM_NAME  # This is the name of the VM in the Azure Arc Connected Server
writevars "K8S_CLUSTER_NAME=${K8S_CLUSTER_NAME}"
writevars "SERVICE_PRINCIPLE_NAME=${SERVICE_PRINCIPLE_NAME}"
writevars "ARC_CONNECTED_SERVER_NAME=${ARC_CONNECTED_SERVER_NAME}"

debug "Variables" 
echo "K8S_CLUSTER_NAME=${K8S_CLUSTER_NAME}"
echo "SERVICE_PRINCIPLE_NAME=${SERVICE_PRINCIPLE_NAME}"
echo "ARC_CONNECTED_SERVER_NAME=${ARC_CONNECTED_SERVER_NAME}"

debug "Install extensions"
az extension add --name monitor-control-service
az extension add --name connectedmachine 
az extension add --name k8s-extension
az extension add --name customlocation

debug "Register resource provider"
az provider register --namespace 'Microsoft.HybridCompute'
az provider register --namespace 'Microsoft.GuestConfiguration'
az provider register --namespace 'Microsoft.HybridConnectivity'
az provider register --namespace 'Microsoft.Kubernetes'
az provider register --namespace 'Microsoft.KubernetesConfiguration'
az provider register --namespace 'Microsoft.ExtendedLocation'
az provider register --namespace 'Microsoft.PolicyInsights'

# ******************************************
#         AUTHENTICATION PreReqs
# ******************************************

    # ---------------------------------------------------- 
    debug "Create service principal for arc enrollment (Scope: resource group)"
    # ---------------------------------------------------- 
    servicePrincipalSecret=`az ad sp create-for-rbac \
                                --name $SERVICE_PRINCIPLE_NAME \
                                --role "Azure Connected Machine Onboarding" \
                                --scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP} \
                                --years 1 \
                                --output tsv \
                                --query password`

    servicePrincipalClientId=`az ad app list \
                                --display-name $SERVICE_PRINCIPLE_NAME \
                                --query [].appId -o tsv`

    debug "servicePrincipalClientId: ${servicePrincipalClientId}"
    debug "servicePrincipalSecret: ${servicePrincipalSecret}"
    writevars "servicePrincipalClientId=${servicePrincipalClientId}"
    writevars "servicePrincipalSecret=${servicePrincipalSecret}"

    # ---------------------------------------------------- 
    debug "Assign role to the service principal"
    # ---------------------------------------------------- 
    az role assignment create \
        --assignee $servicePrincipalClientId \
        --role "Kubernetes Cluster - Azure Arc Onboarding" \
        --scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}

    az role assignment create \
        --assignee $servicePrincipalClientId \
        --role "Azure Connected Machine Onboarding" \
        --scope /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}

# ******************************************
#            ARC CONNECTED SERVER
# ******************************************

    # ---------------------------------------------------- 
    debug "Execute azcmagent connect to start the conected machine agent (Arc Connected Server)"
    # Prerequisites: azcmagent, ServicePrincipalClientId, ServicePrincipalSecret
    # ---------------------------------------------------- 
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        sudo azcmagent connect \
            --service-principal-id $servicePrincipalClientId \
            --service-principal-secret $servicePrincipalSecret \
            --resource-group $RESOURCE_GROUP \
            --tenant-id $TENEANT_ID \
            --location $LOCATION \
            --subscription-id $SUBSCRIPTION_ID \
            --cloud 'AzureCloud'
    
    debug "wait for 60 seconds"
    sleep 60

    CONNECTED_MACHINE_ID=`az resource list \
                            --location $LOCATION \
                            -g $RESOURCE_GROUP\
                            --name $ARC_CONNECTED_SERVER_NAME \
                            --resource-type Microsoft.HybridCompute/machines  \
                            --output tsv \
                            --query [0].id`
    debug "CONNECTED_MACHINE_ID: ${CONNECTED_MACHINE_ID}"
    writevars "CONNECTED_MACHINE_ID=${CONNECTED_MACHINE_ID}"


# ******************************************
#            ARC CONNECTED K8S
# ******************************************

    # ----------------------------------------------------
    debug "Login with Service Principal"
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az login \
            --service-principal \
            -u $servicePrincipalClientId \
            -p $servicePrincipalSecret \
            -t $TENEANT_ID

    # ----------------------------------------------------
    debug "Arc connect k8s cluster"
    # Prerequisites: az login
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az extension add --name connectedk8s

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az connectedk8s connect \
            --name $K8S_CLUSTER_NAME \
            --resource-group $RESOURCE_GROUP
    
    debug "wait for 30 seconds"
    sleep 30

    CONNECTED_CLUSTER_ID=`az connectedk8s show \
                            -n $K8S_CLUSTER_NAME \
                            -g $RESOURCE_GROUP  \
                            --query id \
                            -o tsv`
    debug "CONNECTED_CLUSTER_ID: ${CONNECTED_CLUSTER_ID}"
    writevars "CONNECTED_CLUSTER_ID=${CONNECTED_CLUSTER_ID}"

    echo "#################################################"
    echo "#      Install cluster connect extension        #"
    echo "#################################################"
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az connectedk8s enable-features \
            --features cluster-connect \
            -n $K8S_CLUSTER_NAME \
            -g $RESOURCE_GROUP

    echo "#################################################"
    echo "#             Token Access Method               #"
    echo "#################################################"
    # ----------------------------------------------------
    debug "Create service account to access the cluster"
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create serviceaccount admin-user

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create clusterrolebinding admin-user-binding --clusterrole cluster-admin --serviceaccount default:admin-user

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        /home/azureuser/token.sh
    echo "************************************************"

    # Kubectl access via the service account token - Proxy mode
    debug "Kubectl access via the service account token - Proxy mode"
    debug "az connectedk8s proxy -n $K8S_CLUSTER_NAME -g $RESOURCE_GROUP --token <token from above output> &"


    echo "#################################################"
    echo "#              AAD Access Method                #"
    echo "#################################################"
    AAD_ENTITY_OBJECT_ID=$(az ad signed-in-user show --query objectId -o tsv)
    debug "AAD_ENTITY_OBJECT_ID: ${AAD_ENTITY_OBJECT_ID}"
    writevars "AAD_ENTITY_OBJECT_ID=${AAD_ENTITY_OBJECT_ID}"

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create clusterrolebinding admin-user-binding-2 --clusterrole cluster-admin --user=$AAD_ENTITY_OBJECT_ID

    # Use --group in above command to grant access to a AAD group

    az role assignment create --role "Azure Arc Kubernetes Viewer" --assignee $AAD_ENTITY_OBJECT_ID --scope $CONNECTED_CLUSTER_ID

    # Kubectl access via the AAD - Proxy mode
    debug "Kubectl access via the AAD - Proxy mode"
    debug "az connectedk8s proxy -n $CLUSTER_NAME -g $RESOURCE_GROUP"

    echo "#################################################"
    echo "#              Azure RBAC                       #"
    echo "#################################################"

    # Azure RBAC - API Server -> Guard -> Azure RBAC (Please refer azure_rbac.sh)
    