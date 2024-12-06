@description('Name of the Azure Container Registry')
param name string

@description('Location of the Azure Container Registry')
param location string

@description('Enable admin user for the Azure Container Registry')
param acrAdminUserEnabled bool

resource acr 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

output loginServer string = acr.properties.loginServer
output adminUsername string = listKeys(acr.id, '2022-02-01-preview').username
output adminPassword string = listKeys(acr.id, '2022-02-01-preview').passwords[0].value
