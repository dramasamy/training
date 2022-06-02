source ../arc/arc_enroll_k8s_and_server.sh

LOG_ANALYTICS_WS_NAME=`whoami`-law
DCR_NAME=`whoami`-dcr
writevars "LOG_ANALYTICS_WS_NAME=${LOG_ANALYTICS_WS_NAME}"
writevars "DCR_NAME=${DCR_NAME}"

debug "Variables" 
echo "LOG_ANALYTICS_WS_NAME=${LOG_ANALYTICS_WS_NAME}"
echo "DCR_NAME=${DCR_NAME}"

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
    writevars "LOG_ANALYTICS_WS_ID=${LOG_ANALYTICS_WS_ID}"


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
    writevars "DCR_ID=${DCR_ID}"

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
