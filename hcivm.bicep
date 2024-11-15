param deployPrefix string
param identifier string = ''
param customLocationId string 
param location string = 'eastus2euap'
param csnNicName string 
param l3nNicName string
param vmMemoryMB int = 65536
param vmProcessors int = 16
param galleryImageId string
param publicKeyPath string
param publicKeyData string

@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

@secure()
param adminPassword string

var vmName = '${deployPrefix}-vm${identifier}'

resource hybridCompute 'Microsoft.HybridCompute/machines@2024-07-10' = {
  name: vmName
  location: location
  tags: {}
  kind: 'HCI'
  identity: {
    type: 'SystemAssigned'
  }
}

resource vmInstance 'Microsoft.AzureStackHCI/virtualMachineInstances@2024-08-01-preview' = {
  name: 'default'
  extendedLocation: {
    name: customLocationId
    type: 'CustomLocation'
  }
  scope: hybridCompute
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
          publicKeys: [{path: publicKeyPath, keyData: publicKeyData}]
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
