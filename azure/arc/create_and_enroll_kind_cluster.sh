Help()
{
   # Display Help
   echo "Create a kind cluster and enroll it to Azure Arc, install AMA and container insights."
   echo
   echo "Syntax: create_and_enroll_kind_cluster.sh [-h|g|l]"
   echo "options:"
   echo "g     Resource group. Default: whoami-arc"
   echo "l     Location. Default: eastus"
   echo "h     Print this Help."
   echo
}

debug()
{
   # Display debug message
   echo "**************************************"
   echo "STEP: $1"
   echo "**************************************"
}

# Variables for the script
SUBSCRIPTION_ID=`az account show --query id --output tsv`
TENEANT_ID=`az account show --query tenantId --output tsv`
LOCATION='eastus'
RESOURCE_GROUP=`whoami`-arc
LOG_ANALYTICS_WS_NAME=`whoami`-law
DCR_NAME=`whoami`-dcr
K8S_CLUSTER_NAME=`whoami`-arc-remote-k8s
SERVICE_PRINCIPLE_NAME=`whoami`-arc-sp
VM_NAME=`whoami`-arc-vm
ARC_CONNECTED_SERVER_NAME=$VM_NAME  # This is the name of the VM in the Azure Arc Connected Server 

# Process the input options. Add options as needed.
while getopts ":g:l:h" option; do
   case $option in
      g) # Resource group
         RESOURCE_GROUP=$OPTARG;;
      l) # Location
         LOCATION=$OPTARG;;
      h) # display Help
         Help
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option $option $OPTARG"
         exit;;
   esac
done

debug "Variables" 
echo "SUBSCRIPTION_ID=${SUBSCRIPTION_ID}"
echo "TENEANT_ID=${TENEANT_ID}"
echo "LOCATION=${LOCATION}"
echo "RESOURCE_GROUP=${RESOURCE_GROUP}"
echo "LOG_ANALYTICS_WS_NAME=${LOG_ANALYTICS_WS_NAME}"
echo "DCR_NAME=${DCR_NAME}"
echo "K8S_CLUSTER_NAME=${K8S_CLUSTER_NAME}"
echo "SERVICE_PRINCIPLE_NAME=${SERVICE_PRINCIPLE_NAME}"
echo "ARC_CONNECTED_SERVER_NAME=${ARC_CONNECTED_SERVER_NAME}"
echo "VM_NAME=${VM_NAME}"

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

debug "Create ResourceGroup"
az group create --name $RESOURCE_GROUP --location $LOCATION

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
#            LOGGING PreReqs
# ******************************************

    # ---------------------------------------------------- 
    debug "Create log analytics workspace"
    # ----------------------------------------------------
    LOG_ANALYTICS_WS_ID=`az monitor log-analytics workspace create \
                            -n $LOG_ANALYTICS_WS_NAME \
                            --location $LOCATION \
                            --resource-group $RESOURCE_GROUP \
                            --query id \
                            --output tsv`
    debug "LOG_ANALYTICS_WS_ID: ${LOG_ANALYTICS_WS_ID}"


    # ---------------------------------------------------- 
    debug "Create Data Collection Rule"
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
    debug "DCR_ID: ${DCR_ID}"


    # ---------------------------------------------------- 
    debug "Add syslog data source to the Data Collection Rule"
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
        --custom-data cloud_init.yaml \
        --public-ip-sku Standard

    # az deployment group create \
    #     --resource-group $RESOURCE_GROUP \
    #     --template-file azurevm.json \
    #     --parameters "@azurevm.params.json"  \
    #     --name arctest

    debug "Wait for cloud-init to complete - 200 seconds"
    sleep 200

    VM_IP=`az vm list-ip-addresses \
            --name $VM_NAME \
            --resource-group $RESOURCE_GROUP \
            --query [].virtualMachine.network.publicIpAddresses[].ipAddress \
            -o tsv`
    debug "VM_IP: ${VM_IP}"
    echo "ssh -o StrictHostKeyChecking=no azureuser@${VM_IP}" > ${VM_NAME}.ssh

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
    
    debug "wait for 30 seconds"
    sleep 30

    CONNECTED_MACHINE_ID=`az resource list \
                            --location $LOCATION \
                            -g $RESOURCE_GROUP\
                            --name $ARC_CONNECTED_SERVER_NAME \
                            --resource-type Microsoft.HybridCompute/machines  \
                            --output tsv \
                            --query [0].id`
    debug "CONNECTED_MACHINE_ID: ${CONNECTED_MACHINE_ID}"

# ******************************************
#          CLUSTER VM LOGS VIA AMA
# ******************************************

    #----------------------------------------------------
    debug "Install Azure monitor agent (AMA) via connected machine agent"
    # Prerequisites: Arc for servers (connected machine agent)
    #----------------------------------------------------
    az connectedmachine extension create \
        --name AzureMonitorLinuxAgent \
        --publisher Microsoft.Azure.Monitor \
        --type AzureMonitorLinuxAgent \
        --machine-name $ARC_CONNECTED_SERVER_NAME \
        --resource-group $RESOURCE_GROUP \
        --location $LOCATION

    # ----------------------------------------------------
    debug "Asscoiate the Data Collection Rule with the VM"
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

    # ----------------------------------------------------
    debug "Create service account to access the cluster"
    # ----------------------------------------------------
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create serviceaccount admin-user

    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        kubectl create clusterrolebinding admin-user-binding --clusterrole cluster-admin --serviceaccount default:admin-user

    echo "*************** Token ********************"
    ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
        /home/azureuser/token.sh
    echo "******************************************"

# ******************************************
#          K8S CONTAINER INSIGHTS
# ******************************************

    # ----------------------------------------------------
    debug "Install Azure container monitoring via k8s-extension"
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

# Linux Arc-enabled machines should have Azure Monitor Agent installed /providers/Microsoft.Authorization/policyDefinitions/f17d891d-ff20-46f2-bad3-9e0a5403a4d3
