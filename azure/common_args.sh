#!/bin/sh
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

debug "Create ResourceGroup"
az group create --name $RESOURCE_GROUP --location $LOCATION

debug "Create cleanup script"
echo "az group delete --resource-group  $RESOURCE_GROUP -y" > cleanup.sh
chmod +x cleanup.sh
