param location string = resourceGroup().location
param appServicePlanName string
@allowed([
  'B1'
  'F1'
])
param skuName string
resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
  capacity: 1
  family: 'B'
  name: skuName
  size: 'B1'
  tier: 'Basic'
  }
  kind: 'linux'
  properties: {
  reserved: true
  }
}
output id string = appServicePlan.id
