// Bicep template for creating Azure Management Groups
// This template is designed to create a hierarchy of management groups
// Customize the management group names and structure as needed

// Set the deployment scope to tenant level
// Management groups are created at the tenant scope in Azure

targetScope = 'tenant'

// Example sub-management group under root management group
resource mgMain 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'MainGroup'
  properties: {
    displayName: 'MainGroup'
    details: {
      parent: {
        id: '/providers/Microsoft.Management/managementGroups/root'
      }
    }
  }
}

// Create a series of sub-management groups under the main group
resource mgLandingZones 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'LandingZones'
  properties: {
    displayName: 'LandingZones'
    details: {
      parent: {
        id: mgMain.id
      }
    }
  }
}

resource mgPlatform 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'Platform'
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: mgMain.id
      }
    }
  }
}

resource mgConnectivity 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'Connectivity'
  properties: {
    displayName: 'Connectivity'
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

resource mgIdentity 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'Identity'
  properties: {
    displayName: 'Identity'
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

resource mgManagement 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'Management'
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: mgPlatform.id
      }
    }
  }
}

// Example sub-groups for LandingZones
resource Applications 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'Applications'
  properties: {
    displayName: 'Applications'
    details: {
      parent: {
        id: mgLandingZones.id
      }
    }
  }
}

resource SharedServices 'Microsoft.Management/managementGroups@2021-04-01' = {
  name: 'SharedServices'
  properties: {
    displayName: 'SharedServices'
    details: {
      parent: {
        id: mgLandingZones.id
      }
    }
  }
}
