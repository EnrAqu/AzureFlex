param location string = 'westeurope' // Change this to your preferred location
param vmName string = 'myVM'
param adminUsername string = 'adminuser' // Change this to your preferred username
param adminPassword string = 'P@ssw0rd' // Change this to your preferred password

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: '${vmName}Vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  tags: {
    usage: 'Virtual Network for ${vmName}'
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: '${vmName}PublicIP'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  tags: {
    usage: 'Public IP for ${vmName}'
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-06-01' = {
  name: '${vmName}NIC'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${virtualNetwork.id}/subnets/default'
          }
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
  }
  tags: {
    usage: 'Network Interface for ${vmName}'
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B4ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 100
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
  tags: {
    usage: 'Virtual Machine ${vmName}'
  }
}
