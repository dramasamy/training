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

param numberOfVMs int // Number of VMs to create

// Module for VM 1
module vm1 './hcivm.bicep' = if (numberOfVMs >= 1) {
  name: 'vmDeployment-1'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 1
  }
}

// Module for VM 2
module vm2 './hcivm.bicep' = if (numberOfVMs >= 2) {
  name: 'vmDeployment-2'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 2
  }
  dependsOn: [
    vm1
  ]
}

// Module for VM 3
module vm3 './hcivm.bicep' = if (numberOfVMs >= 3) {
  name: 'vmDeployment-3'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 3
  }
  dependsOn: [
    vm2
  ]
}

// Module for VM 4
module vm4 './hcivm.bicep' = if (numberOfVMs >= 4) {
  name: 'vmDeployment-4'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 4
  }
  dependsOn: [
    vm3
  ]
}

// Module for VM 5
module vm5 './hcivm.bicep' = if (numberOfVMs >= 5) {
  name: 'vmDeployment-5'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 5
  }
  dependsOn: [
    vm4
  ]
}

// Module for VM 6
module vm6 './hcivm.bicep' = if (numberOfVMs >= 6) {
  name: 'vmDeployment-6'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 6
  }
  dependsOn: [
    vm5
  ]
}

// Module for VM 7
module vm7 './hcivm.bicep' = if (numberOfVMs >= 7) {
  name: 'vmDeployment-7'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 7
  }
  dependsOn: [
    vm6
  ]
}

// Module for VM 8
module vm8 './hcivm.bicep' = if (numberOfVMs >= 8) {
  name: 'vmDeployment-8'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 8
  }
  dependsOn: [
    vm7
  ]
}

// Module for VM 9
module vm9 './hcivm.bicep' = if (numberOfVMs >= 9) {
  name: 'vmDeployment-9'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 9
  }
  dependsOn: [
    vm8
  ]
}

// Module for VM 10
module vm10 './hcivm.bicep' = if (numberOfVMs >= 10) {
  name: 'vmDeployment-10'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 10
  }
  dependsOn: [
    vm9
  ]
}

// Module for VM 11
module vm11 './hcivm.bicep' = if (numberOfVMs >= 11) {
  name: 'vmDeployment-11'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 11
  }
  dependsOn: [
    vm10
  ]
}

// Module for VM 12
module vm12 './hcivm.bicep' = if (numberOfVMs >= 12) {
  name: 'vmDeployment-12'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 12
  }
  dependsOn: [
    vm11
  ]
}

// Module for VM 13
module vm13 './hcivm.bicep' = if (numberOfVMs >= 13) {
  name: 'vmDeployment-13'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 13
  }
  dependsOn: [
    vm12
  ]
}

// Module for VM 14
module vm14 './hcivm.bicep' = if (numberOfVMs >= 14) {
  name: 'vmDeployment-14'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 14
  }
  dependsOn: [
    vm13
  ]
}

// Module for VM 15
module vm15 './hcivm.bicep' = if (numberOfVMs >= 15) {
  name: 'vmDeployment-15'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 15
  }
  dependsOn: [
    vm14
  ]
}

// Module for VM 16
module vm16 './hcivm.bicep' = if (numberOfVMs >= 16) {
  name: 'vmDeployment-16'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 16
  }
  dependsOn: [
    vm15
  ]
}

// Module for VM 17
module vm17 './hcivm.bicep' = if (numberOfVMs >= 17) {
  name: 'vmDeployment-17'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 17
  }
  dependsOn: [
    vm16
  ]
}

// Module for VM 18
module vm18 './hcivm.bicep' = if (numberOfVMs >= 18) {
  name: 'vmDeployment-18'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 18
  }
  dependsOn: [
    vm17
  ]
}

// Module for VM 19
module vm19 './hcivm.bicep' = if (numberOfVMs >= 19) {
  name: 'vmDeployment-19'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 19
  }
  dependsOn: [
    vm18
  ]
} 

// Module for VM 20
module vm20 './hcivm.bicep' = if (numberOfVMs >= 20) {
  name: 'vmDeployment-20'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 20
  }
  dependsOn: [
    vm19
  ]
}

// Module for VM 21
module vm21 './hcivm.bicep' = if (numberOfVMs >= 21) {
  name: 'vmDeployment-21'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 21
  }
  dependsOn: [
    vm20
  ]
}

// Module for VM 22
module vm22 './hcivm.bicep' = if (numberOfVMs >= 22) {
  name: 'vmDeployment-22'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 22
  }
  dependsOn: [
    vm21
  ]
}

// Module for VM 23
module vm23 './hcivm.bicep' = if (numberOfVMs >= 23) {
  name: 'vmDeployment-23'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 23
  }
  dependsOn: [
    vm22
  ]
}

// Module for VM 24
module vm24 './hcivm.bicep' = if (numberOfVMs >= 24) {
  name: 'vmDeployment-24'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 24
  }
  dependsOn: [
    vm23
  ]
}

// Module for VM 25
module vm25 './hcivm.bicep' = if (numberOfVMs >= 25) {
  name: 'vmDeployment-25'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 25
  }
  dependsOn: [
    vm24
  ]
}

// Module for VM 26
module vm26 './hcivm.bicep' = if (numberOfVMs >= 26) {
  name: 'vmDeployment-26'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 26
  }
  dependsOn: [
    vm25
  ]
}

// Module for VM 27
module vm27 './hcivm.bicep' = if (numberOfVMs >= 27) {
  name: 'vmDeployment-27'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 27
  }
  dependsOn: [
    vm26
  ]
}

// Module for VM 28
module vm28 './hcivm.bicep' = if (numberOfVMs >= 28) {
  name: 'vmDeployment-28'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 28
  }
  dependsOn: [
    vm27
  ]
}

// Module for VM 29
module vm29 './hcivm.bicep' = if (numberOfVMs >= 29) {
  name: 'vmDeployment-29'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 29
  }
  dependsOn: [
    vm28
  ]
}

// Module for VM 30
module vm30 './hcivm.bicep' = if (numberOfVMs >= 30) {
  name: 'vmDeployment-30'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 30
  }
  dependsOn: [
    vm29
  ]
}

// Module for VM 31
module vm31 './hcivm.bicep' = if (numberOfVMs >= 31) {
  name: 'vmDeployment-31'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 31
  }
  dependsOn: [
    vm30
  ]
}


// Module for VM 32
module vm32 './hcivm.bicep' = if (numberOfVMs >= 32) {
  name: 'vmDeployment-32'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 32
  }
  dependsOn: [
    vm31
  ]
}

// Module for VM 33
module vm33 './hcivm.bicep' = if (numberOfVMs >= 33) {
  name: 'vmDeployment-33'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 33
  }
  dependsOn: [
    vm32
  ]
}

// Module for VM 34
module vm34 './hcivm.bicep' = if (numberOfVMs >= 34) {
  name: 'vmDeployment-34'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 34
  }
  dependsOn: [
    vm33
  ]
}

// Module for VM 35
module vm35 './hcivm.bicep' = if (numberOfVMs >= 35) {
  name: 'vmDeployment-35'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 35
  }
  dependsOn: [
    vm34
  ]
}

// Module for VM 36
module vm36 './hcivm.bicep' = if (numberOfVMs >= 36) {
  name: 'vmDeployment-36'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 36
  }
  dependsOn: [
    vm35
  ]
}

// Module for VM 37
module vm37 './hcivm.bicep' = if (numberOfVMs >= 37) {
  name: 'vmDeployment-37'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 37
  }
  dependsOn: [
    vm36
  ]
}

// Module for VM 38
module vm38 './hcivm.bicep' = if (numberOfVMs >= 38) {
  name: 'vmDeployment-38'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 38
  }
  dependsOn: [
    vm37
  ]
}

// Module for VM 39
module vm39 './hcivm.bicep' = if (numberOfVMs >= 39) {
  name: 'vmDeployment-39'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 39
  }
  dependsOn: [
    vm38
  ]
}

// Module for VM 40
module vm40 './hcivm.bicep' = if (numberOfVMs >= 40) {
  name: 'vmDeployment-40'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 40
  }
  dependsOn: [
    vm39
  ]
}

// Module for VM 41
module vm41 './hcivm.bicep' = if (numberOfVMs >= 41) {
  name: 'vmDeployment-41'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 41
  }
  dependsOn: [
    vm40
  ]
}

// Module for VM 42
module vm42 './hcivm.bicep' = if (numberOfVMs >= 42) {
  name: 'vmDeployment-42'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 42
  }
  dependsOn: [
    vm41
  ]
}

// Module for VM 43
module vm43 './hcivm.bicep' = if (numberOfVMs >= 43) {
  name: 'vmDeployment-43'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 43
  }
  dependsOn: [
    vm42
  ]
}

// Module for VM 44
module vm44 './hcivm.bicep' = if (numberOfVMs >= 44) {
  name: 'vmDeployment-44'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 44
  }
  dependsOn: [
    vm43
  ]
}

// Module for VM 45
module vm45 './hcivm.bicep' = if (numberOfVMs >= 45) {
  name: 'vmDeployment-45'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 45
  }
  dependsOn: [
    vm44
  ]
}

// Module for VM 46
module vm46 './hcivm.bicep' = if (numberOfVMs >= 46) {
  name: 'vmDeployment-46'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 46
  }
  dependsOn: [
    vm45
  ]
}

// Module for VM 47
module vm47 './hcivm.bicep' = if (numberOfVMs >= 47) {
  name: 'vmDeployment-47'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 47
  }
  dependsOn: [
    vm46
  ]
}

// Module for VM 48
module vm48 './hcivm.bicep' = if (numberOfVMs >= 48) {
  name: 'vmDeployment-48'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 48
  }
  dependsOn: [
    vm47
  ]
}

// Module for VM 49
module vm49 './hcivm.bicep' = if (numberOfVMs >= 49) {
  name: 'vmDeployment-49'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 49
  }
  dependsOn: [
    vm48
  ]
}

// Module for VM 50
module vm50 './hcivm.bicep' = if (numberOfVMs >= 50) {
  name: 'vmDeployment-50'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 50
  }
  dependsOn: [
    vm49
  ]
}

// Module for VM 51
module vm51 './hcivm.bicep' = if (numberOfVMs >= 51) {
  name: 'vmDeployment-51'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 51
  }
  dependsOn: [
    vm50
  ]
}

// Module for VM 52
module vm52 './hcivm.bicep' = if (numberOfVMs >= 52) {
  name: 'vmDeployment-52'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 52
  }
  dependsOn: [
    vm51
  ]
}

// Module for VM 53
module vm53 './hcivm.bicep' = if (numberOfVMs >= 53) {
  name: 'vmDeployment-53'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 53
  }
  dependsOn: [
    vm52
  ]
}

// Module for VM 54
module vm54 './hcivm.bicep' = if (numberOfVMs >= 54) {
  name: 'vmDeployment-54'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 54
  }
  dependsOn: [
    vm53
  ]
}

// Module for VM 55
module vm55 './hcivm.bicep' = if (numberOfVMs >= 55) {
  name: 'vmDeployment-55'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 55
  }
  dependsOn: [
    vm54
  ]
}

// Module for VM 56
module vm56 './hcivm.bicep' = if (numberOfVMs >= 56) {
  name: 'vmDeployment-56'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 56
  }
  dependsOn: [
    vm55
  ]
}

// Module for VM 57
module vm57 './hcivm.bicep' = if (numberOfVMs >= 57) {
  name: 'vmDeployment-57'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 57
  }
  dependsOn: [
    vm56
  ]
}

// Module for VM 58
module vm58 './hcivm.bicep' = if (numberOfVMs >= 58) {
  name: 'vmDeployment-58'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 58
  }
  dependsOn: [
    vm57
  ]
}

// Module for VM 59
module vm59 './hcivm.bicep' = if (numberOfVMs >= 59) {
  name: 'vmDeployment-59'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 59
  }
  dependsOn: [
    vm58
  ]
}

// Module for VM 60
module vm60 './hcivm.bicep' = if (numberOfVMs >= 60) {
  name: 'vmDeployment-60'
  params: {
    deployPrefix: deployPrefix
    identifier: identifier
    customLocationId: customLocationId
    location: location
    csnNicName: csnNicName
    l3nNicName: l3nNicName
    vmMemoryMB: vmMemoryMB
    vmProcessors: vmProcessors
    galleryImageId: galleryImageId
    publicKeyPath: publicKeyPath
    publicKeyData: publicKeyData
    osType: osType
    adminPassword: adminPassword
    vmIndex: 60
  }
  dependsOn: [
    vm59
  ]
}
