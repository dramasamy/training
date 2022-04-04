source ../common_args.sh

VNET_NAME=`whoami`-demo-vnet
SUBNET_NAME_1=`whoami`-demo-subnet-1
SUBNET_NAME_2=`whoami`-demo-subnet-2

debug "Create vnet with subnet"
az network vnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME \
   --address-prefix 10.0.0.0/16 \
   --subnet-name $SUBNET_NAME_1 \
   --subnet-prefix 10.0.0.0/24

debug "list available vnets"
az network vnet list -g $RESOURCE_GROUP

debug "Create subnet and add it to vnet"
az network vnet subnet create \
   -g $RESOURCE_GROUP \
   -n $SUBNET_NAME_2 \
   --vnet-name $VNET_NAME \
   --address-prefixes "10.0.1.0/24"
