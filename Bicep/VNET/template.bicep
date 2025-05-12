// Azure VNet with Subnets, NSGs, and Route Tables
// This template creates a VNet with multiple subnets, including some without NSGs or Route Tables.
// Explanation: Not all subnets require NSGs or route tables. For example, internal-only subnets that do not communicate externally may not need them.

targetScope = 'resourceGroup'

@description('Name of the virtual network')
param vnetName string

@description('Location for the virtual network')
param location string

@description('Address prefix for the virtual network')
param addressPrefix string

@description('Array of subnet configurations')
param subnets array

@description('Name of the Azure Firewall for routing')
param firewallName string

@description('Name of the route table')
param routeTableName string

@description('Name of the NSG')
param nsgName string

// Create Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [addressPrefix]
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.prefix
          networkSecurityGroup: subnet.nsg ? {
            id: resourceId('Microsoft.Network/networkSecurityGroups', subnet.nsg)
          } : null
          routeTable: subnet.routeTable ? {
            id: resourceId('Microsoft.Network/routeTables', subnet.routeTable)
          } : null
        }
      }
    ]
  }
}

// Example Subnet Configuration Array
// subnets = [
//   { name: 'subnet1', prefix: '10.0.1.0/24', nsg: 'myNSG', routeTable: 'myRouteTable' },
//   { name: 'subnet2', prefix: '10.0.2.0/24' }, // No NSG or Route Table - Internal Only
//   { name: 'subnet3', prefix: '10.0.3.0/24', nsg: 'myNSG' },
// ]

// Create Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = if (length(subnets) > 0) {
  name: nsgName
  location: location
}

// Create Route Table with Firewall Route
resource routeTable 'Microsoft.Network/routeTables@2023-05-01' = if (length(subnets) > 0) {
  name: routeTableName
  location: location
  properties: {
    routes: [
      {
        name: 'RouteToFirewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.0.4' // Example Firewall IP
        }
      }
    ]
  }
}