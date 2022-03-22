
# Variables for the script
SUBSCRIPTION_ID=`az account show --query id --output tsv`
TENEANT_ID=`az account show --query tenantId --output tsv`
LOCATION='eastus'
RESOURCE_GROUP=dramasamy-arc
LOG_ANALYTICS_WS_NAME=arcTestLaw
DCR_NAME=arcConnectedServerDcr
K8S_CLUSTER_NAME=upfCluster

# Install extensions
az extension add --name monitor-control-service
az extension add --name connectedmachine 
az extension add --name k8s-extension
az extension add --name customlocation

# Register resource provider
az provider register --namespace 'Microsoft.HybridCompute'
az provider register --namespace 'Microsoft.GuestConfiguration'
az provider register --namespace 'Microsoft.HybridConnectivity'
az provider register --namespace 'Microsoft.Kubernetes'
az provider register --namespace 'Microsoft.KubernetesConfiguration'
az provider register --namespace 'Microsoft.ExtendedLocation'
az provider register --namespace 'Microsoft.PolicyInsights'

# Debug info
echo "SUBSCRIPTION_ID=${SUBSCRIPTION_ID}"
echo "TENEANT_ID=${TENEANT_ID}"
echo "LOCATION=${LOCATION}"
echo "RESOURCE_GROUP=${RESOURCE_GROUP}"
echo "LOG_ANALYTICS_WS_NAME=${LOG_ANALYTICS_WS_NAME}"
echo "DCR_NAME=${DCR_NAME}"
echo "K8S_CLUSTER_NAME=${K8S_CLUSTER_NAME}"

# Create ResourceGroup
az group create --name $RESOURCE_GROUP --location $LOCATION

# ******************************************
#         AUTHENTICATION PreReqs
# ******************************************

    # ---------------------------------------------------- 
    # Create service principal for arc enrollment (Scope: resource group)
    # ---------------------------------------------------- 
    servicePrincipalSecret=`az ad sp create-for-rbac \
                                --name arc-test-sp \
                                --role "Azure Connected Machine Onboarding" \
                                --scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP} \
                                --years 1 \
                                --output tsv \
                                --query password`

    servicePrincipalClientId=`az ad app list \
                                --display-name arc-test-sp \
                                --query [].appId -o tsv`

    echo "servicePrincipalClientId: ${servicePrincipalClientId}"
    echo "servicePrincipalSecret: ${servicePrincipalSecret}"


    # ---------------------------------------------------- 
    # Assign role to the service principal
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
#            LOGGING PreReqs
# ******************************************

    # ---------------------------------------------------- 
    # Create log analytics workspace
    # ----------------------------------------------------
    LOG_ANALYTICS_WS_ID=`az monitor log-analytics workspace create \
                            -n $LOG_ANALYTICS_WS_NAME \
                            --location $LOCATION \
                            --resource-group $RESOURCE_GROUP \
                            --query id \
                            --output tsv`
    echo "LOG_ANALYTICS_WS_ID: ${LOG_ANALYTICS_WS_ID}"


    # ---------------------------------------------------- 
    # Create Data Collection Rule
    # Prerequisites: Log Analytics Workspace
    # ----------------------------------------------------
    DCR_ID=`az monitor data-collection rule create \
                --resource-group $RESOURCE_GROUP \
                --name $DCR_NAME \
                --location $LOCATION \
                --log-analytics resource-id=$LOG_ANALYTICS_WS_ID name=$LOG_ANALYTICS_WS_NAME \
                --data-flows streams=Microsoft-Syslog destinations=$LOG_ANALYTICS_WS_NAME \
                --query id \
                --output tsv`
    echo "DCR_ID: ${DCR_ID}"


    # ---------------------------------------------------- 
    # Add syslog data source to the Data Collection Rule
    # ----------------------------------------------------
    az monitor data-collection rule syslog add \
        --rule-name $DCR_NAME \
        --resource-group $RESOURCE_GROUP \
        --name "syslogBase" \
        --facility-names "syslog" \
        --log-levels "Alert" "Critical" \
        --streams "Microsoft-Syslog"


# ******************************************
#       CREATE K8S WORKLOAD CLUSTER
# ******************************************

    # ---------------------------------------------------- 
    # Create VM and install kubectl, kind, and azure-cli
    # ---------------------------------------------------- 
    az deployment group create \
        --resource-group $RESOURCE_GROUP \
        --template-file azurevm.json \
        --parameters "@azurevm.params.json"  \
        --name arctest

    # Wait for cloud-init to complete
    sleep 200

    VM_IP=`az vm list-ip-addresses \
            --name arctest-vm \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    echo "VM_IP: ${VM_IP}"


# ******************************************
#            ARC CONNECTED SERVER
# ******************************************

    # ---------------------------------------------------- 
    # Execute azcmagent connect to start the conected machine agent (Arc Connected Server)
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


# ******************************************
#          CLUSTER VM LOGS VIA AMA
# ******************************************

    #----------------------------------------------------
    # Install Azure monitor agent (AMA) via connected machine agent
    # Prerequisites: Arc for servers (connected machine agent)
    #----------------------------------------------------
    az connectedmachine extension create \
        --name AzureMonitorLinuxAgent \
        --publisher Microsoft.Azure.Monitor \
        --type AzureMonitorLinuxAgent \
        --machine-name arctest-vm \
        --resource-group $RESOURCE_GROUP \
        --location $LOCATION

    CONNECTED_MACHINE_ID=`az resource list \
                            --location $LOCATION \
                            -g $RESOURCE_GROUP\
                            --name arctest-vm \
                            --resource-type Microsoft.HybridCompute/machines  \
                            --output tsv \
                            --query [0].id`
    echo "CONNECTED_MACHINE_ID: ${CONNECTED_MACHINE_ID}"

    # ----------------------------------------------------
    # Asscoiate the Data Collection Rule with the VM
    # Prerequisites: Data Collection Rule (DCR)
    # ----------------------------------------------------
    az monitor data-collection rule association create \
        --name "ArcServerDcrAssociation" \
        --rule-id $DCR_ID \
        --resource $CONNECTED_MACHINE_ID


# ******************************************
#            ARC CONNECTED K8S
# ******************************************

    # ----------------------------------------------------
    # Login via Service Principal
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az login \
            --service-principal \
            -u $servicePrincipalClientId \
            -p $servicePrincipalSecret \
            -t $TENEANT_ID

    # ----------------------------------------------------
    # Arc connected k8s cluster
    # Prerequisites: az login
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az extension add --name connectedk8s

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az connectedk8s connect \
            --name $K8S_CLUSTER_NAME \
            --resource-group $RESOURCE_GROUP

    CONNECTED_CLUSTER_ID=`az connectedk8s show \
                            -n $K8S_CLUSTER_NAME \
                            -g $RESOURCE_GROUP  \
                            --query id \
                            -o tsv`
    echo "CONNECTED_CLUSTER_ID: ${CONNECTED_CLUSTER_ID}"

    # ----------------------------------------------------
    # Create service account to access the cluster
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create serviceaccount admin-user

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create clusterrolebinding admin-user-binding --clusterrole cluster-admin --serviceaccount default:admin-user

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        /home/azureuser/token.sh

# ******************************************
#          K8S CONTAINER INSIGHTS
# ******************************************

    # ----------------------------------------------------
    # Azure container monitoring
    # Prerequisites: Log analytics workspace
    # ----------------------------------------------------
    az k8s-extension create \
        --name azuremonitor-containers \
        --cluster-name $K8S_CLUSTER_NAME \
        --resource-group $RESOURCE_GROUP \
        --cluster-type connectedClusters \
        --extension-type Microsoft.AzureMonitor.Containers \
        --configuration-settings logAnalyticsWorkspaceResourceID=$LOG_ANALYTICS_WS_ID


# ****************************************** 
#      Not Required - Expiriments
# ******************************************
    # ---------------------------------------------------- 
    # Start proxy for kubectl using token (without Cluster-Connect)
    # ---------------------------------------------------- 
    # az connectedk8s proxy -n $K8S_CLUSTER_NAME -g $RESOURCE_GROUP --token $TOKEN

    # Enable cluster connect feature
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        az connectedk8s enable-features \
            -n $K8S_CLUSTER_NAME \
            -g $RESOURCE_GROUP \
            --features cluster-connect custom-locations

    # Install Azure policy extension
    az k8s-extension create \
        --cluster-type connectedClusters \
        --cluster-name $K8S_CLUSTER_NAME \
        --resource-group $RESOURCE_GROUP \
        --extension-type Microsoft.PolicyInsights \
        --name azurepolicy