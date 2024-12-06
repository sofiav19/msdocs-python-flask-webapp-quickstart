@description('Name of the App Service Plan')
param name string

@description('Location of the App Service Plan')
param location string

@description('SKU configuration for the App Service Plan')
param sku object

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: name
  location: location
  sku: sku
  kind: 'Linux'
  properties: {
    reserved: sku.reserved
  }
}

output id string = appServicePlan.id
