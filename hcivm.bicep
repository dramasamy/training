param deployPrefix string
param identifier string
param customLocationId string
param location string
param csnNicName string
param l3nNicName string
param vmMemoryMB int
param vmProcessors int
param galleryImageId string
param publicKeyPath string
param publicKeyData string
param osType string
@secure()
param adminPassword string
param vmIndex int

// Compute unique VM name
var vmName = '${deployPrefix}-vm${identifier}-${vmIndex}'

// Hybrid Compute Resource
resource vm 'Microsoft.HybridCompute/machines@2024-07-10' = {
  name: vmName
  location: location
  tags: {}
  kind: 'HCI'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

// VM Instance Resource
resource vmInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-08-01-preview' = {
  name: 'default' // Name is fixed as 'default'
  extendedLocation: {
    name: customLocationId
    type: 'CustomLocation'
  }
  scope: vm
  properties: {
    hardwareProfile: {
      memoryMB: vmMemoryMB
      processors: vmProcessors
      vmSize: 'Custom'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: csnNicName
        }
        {
          id: l3nNicName
        }
      ]
    }
    osProfile: {
      adminPassword: adminPassword
      adminUsername: 'azureuser'
      windowsConfiguration: osType == 'Windows' ? {
        provisionVMAgent: true
        provisionVMConfigAgent: true
        enableAutomaticUpdates: true
      } : null
      linuxConfiguration: osType == 'Linux' ? {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: publicKeyPath
              keyData: publicKeyData
            }
          ]
        }
        provisionVMAgent: false
        provisionVMConfigAgent: false
      } : null
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
      }
      enableTPM: true
    }
    storageProfile: {
      imageReference: {
        id: galleryImageId
      }
    }
  }
}
