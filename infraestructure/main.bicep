
param appServicePlanSkuName string
param appServicePlanName string
param appServiceWebsiteBEName string
param location string = resourceGroup().location
param containerRegistryName string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'
param userAlias string
param keyVaultName string

module keyVault 'modules/key-vault.bicep' = {
  name: 'kv-${userAlias}'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true
}
}

module containerRegistry 'modules/acr.bicep' = {
    name: 'cr-${userAlias}'
    params: {
    name: containerRegistryName
    location: location
    keyVaultName: 'kv-${userAlias}'
  }
  }
  module appServicePlan 'modules/app-service-plan.bicep' = {
    name: 'asp-${userAlias}'
    params: {
    location: location
    appServicePlanName: appServicePlanName
    skuName: appServicePlanSkuName
  }
  }



  module appServiceWebsiteBE 'modules/web-app.bicep' = {
    name: 'appfe-${userAlias}'
    params: {
    name: appServiceWebsiteBEName
    location: location
    appServicePlanId: appServicePlan.outputs.id
    appCommandLine: ''
    dockerRegistryName: containerRegistryName
    dockerRegistryImageName: dockerRegistryImageName
    dockerRegistryImageVersion: dockerRegistryImageVersion
    dockerRegistryServerUrl: 'https://${containerRegistryName}.azurecr.io'
    keyVaultName: keyVaultName
  }
  dependsOn: [
    containerRegistry
    appServicePlan
    keyVault
  ]
}
