source arc_enroll_k8s_and_server.sh minikube

# Create a new Azure AD application and get its appId value. This value is used in later steps as serverApplicationId.
debug "Create a new server Azure AD application and get its appId value."
CLUSTER_NAME=$K8S_CLUSTER_NAME
SERVER_APP_ID=$(az ad app create --display-name "${CLUSTER_NAME}Server" --query appId -o tsv)
debug "Created server application with appId: $SERVER_APP_ID"
writevars "SERVER_APP_ID=${SERVER_APP_ID}"
writevars "CLUSTER_NAME=${CLUSTER_NAME}"

debug "Update the application's group membership claims: All."
az ad app update --id "${SERVER_APP_ID}" --set groupMembershipClaims=All

debug "Create a service principal and get its password field value."
# This value is required later as serverApplicationSecret when 
# you're enabling this feature on the cluster.
az ad sp create --id "${SERVER_APP_ID}"
SERVER_APP_SECRET=$(az ad sp credential reset --name "${SERVER_APP_ID}" --credential-description "ArcSecret" --query password -o tsv)
writevars "SERVER_APP_SECRET=${SERVER_APP_SECRET}"

debug "Grant 'Sign in and read user profile' API permissions to the application:"
az ad app permission add --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000 --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope
az ad app permission grant --id "${SERVER_APP_ID}" --api 00000003-0000-0000-c000-000000000000

# Create a new Azure AD application and get its appId value.
# This value is used in later steps as clientApplicationId.
debug "Create a new client Azure AD application and get its appId value."
CLIENT_APP_ID=$(az ad app create --display-name "${CLUSTER_NAME}Client" --native-app --reply-urls "api://${TENANT_ID}/ServerAnyUniqueSuffix" --query appId -o tsv)
debug "Created client application with appId: $CLIENT_APP_ID"
writevars "CLIENT_APP_ID=${CLIENT_APP_ID}"

debug "Create a service principal for this client application"
az ad sp create --id "${CLIENT_APP_ID}"

debug "Get the oAuthPermissionId value for the server application"
oAuthPermissionId=$(az ad app show --id "${SERVER_APP_ID}" --query "oauth2Permissions[0].id" -o tsv)
debug "oAuthPermissionId: $oAuthPermissionId"
writevars "oAuthPermissionId=${oAuthPermissionId}"

debug "Grant the required permissions for the client application"
az ad app permission add --id "${CLIENT_APP_ID}" --api "${SERVER_APP_ID}" --api-permissions $oAuthPermissionId=Scope
az ad app permission grant --id "${CLIENT_APP_ID}" --api "${SERVER_APP_ID}"

debug "Create .accessCheck.json"
cat <<EOF> .accessCheck.json
{
  "Name": "Read authorization",
  "IsCustom": true,
  "Description": "Read authorization",
  "Actions": ["Microsoft.Authorization/*/read"],
  "NotActions": [],
  "DataActions": [],
  "NotDataActions": [],
  "AssignableScopes": [
    "/subscriptions/$SUBSCRIPTION_ID"
  ]
}
EOF

# Run the following command to create the new custom role:
ROLE_ID=$(az role definition create --role-definition ./.accessCheck.json --query id -o tsv)
debug "Role ID: $ROLE_ID"
writevars "ROLE_ID=${ROLE_ID}"

# Create a role assignment on the server application as assignee by using the role that you created:
az role assignment create --role "${ROLE_ID}" --assignee "${SERVER_APP_ID}" --scope /subscriptions/$SUBSCRIPTION_ID

# Enable Azure role-based access control (RBAC) on your Azure Arc-enabled
# Kubernetes cluster by running the following command:
ssh -o "StrictHostKeyChecking no" azureuser@${VM_IP} \
    az connectedk8s enable-features \
        -n $CLUSTER_NAME \
        -g $RESOURCE_GROUP \
        --features azure-rbac \
        --app-id "${SERVER_APP_ID}" \
        --app-secret "${SERVER_APP_SECRET}"
