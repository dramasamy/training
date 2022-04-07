source ../common/args.sh

VNET_NAME_1=`whoami`-demo-vnet-1
VNET_NAME_2=`whoami`-demo-vnet-2
SUBNET_NAME_1=`whoami`-demo-subnet-1
SUBNET_NAME_2=`whoami`-demo-subnet-2

debug "Create vnet $VNET_NAME_1 with subnet $SUBNET_NAME_1"
az network vnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_1 \
   --address-prefix 10.0.0.0/16 \
   --subnet-name $SUBNET_NAME_1 \
   --subnet-prefix 10.0.0.0/24

debug "Create subnet $SUBNET_NAME_2 and add it to vnet $VNET_NAME_1"
az network vnet subnet create \
   -g $RESOURCE_GROUP \
   -n $SUBNET_NAME_2 \
   --vnet-name $VNET_NAME_1 \
   --address-prefixes "10.0.1.0/24"

debug "Create vnet $VNET_NAME_2 with subnet $SUBNET_NAME_1"
az network vnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_2 \
   --address-prefix 10.1.0.0/16 \
   --subnet-name $SUBNET_NAME_1 \
   --subnet-prefix 10.1.0.0/24

debug "list available vnets"
az network vnet list -g $RESOURCE_GROUP

debug "Create subnet $SUBNET_NAME_2 and add it to vnet $VNET_NAME_2"
az network vnet subnet create \
   -g $RESOURCE_GROUP \
   -n $SUBNET_NAME_2 \
   --vnet-name $VNET_NAME_2 \
   --address-prefixes "10.1.1.0/24"
