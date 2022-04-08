source ../common/args.sh

VNET_NAME_1=`whoami`-vnet1
VNET_NAME_2=`whoami`-vnet2
VNET_NAME_1_SUBNET_NAME_1=`whoami`-vnet1-subnet1
VNET_NAME_1_SUBNET_NAME_2=`whoami`-vnet1-subnet2
VNET_NAME_2_SUBNET_NAME_1=`whoami`-vnet2-subnet1
VNET_NAME_2_SUBNET_NAME_2=`whoami`-vnet2-subnet2
writevars "VNET_NAME_1=${VNET_NAME_1}"
writevars "VNET_NAME_2=${VNET_NAME_2}"
writevars "VNET_NAME_1_SUBNET_NAME_1=${VNET_NAME_1_SUBNET_NAME_1}"
writevars "VNET_NAME_1_SUBNET_NAME_2=${VNET_NAME_1_SUBNET_NAME_2}"
writevars "VNET_NAME_2_SUBNET_NAME_1=${VNET_NAME_2_SUBNET_NAME_1}"
writevars "VNET_NAME_2_SUBNET_NAME_2=${VNET_NAME_2_SUBNET_NAME_2}"

debug "Create vnet $VNET_NAME_1 with subnet $VNET_NAME_1_SUBNET_NAME_1"
az network vnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_1 \
   --address-prefixes 10.16.0.0/16 172.16.0.0/16 \
   --subnet-name $VNET_NAME_1_SUBNET_NAME_1 \
   --subnet-prefix 10.16.1.0/24

debug "Create subnet $VNET_NAME_1_SUBNET_NAME_2 and add it to vnet $VNET_NAME_1"
az network vnet subnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_1_SUBNET_NAME_2 \
   --vnet-name $VNET_NAME_1 \
   --address-prefixes 172.16.1.0/24

debug "Create vnet $VNET_NAME_2 with subnet $VNET_NAME_2_SUBNET_NAME_1"
az network vnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_2 \
   --address-prefix 10.17.0.0/16 172.17.0.0/16 \
   --subnet-name $VNET_NAME_2_SUBNET_NAME_1 \
   --subnet-prefix 10.17.1.0/24

debug "Create subnet $VNET_NAME_2_SUBNET_NAME_2 and add it to vnet $VNET_NAME_2"
az network vnet subnet create \
   -g $RESOURCE_GROUP \
   -n $VNET_NAME_2_SUBNET_NAME_2 \
   --vnet-name $VNET_NAME_2 \
   --address-prefixes  172.17.1.0/24

debug "list available vnets"
az network vnet list -g $RESOURCE_GROUP
