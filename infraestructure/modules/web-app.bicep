param location string = resourceGroup().location
param name string
param appServicePlanId string
param dockerRegistryName string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'
param appCommandLine string = ''
@secure()
param dockerRegistryServerUrl string
param keyVaultName string

var appSettings = [
  { name: 'DOCKER_REGISTRY_SERVER_URL', value: dockerRegistryServerUrl }
  { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: '@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/adminCredentialsKeyVaultSecretUserName/)' }
  { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: '@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/adminCredentialsKeyVaultSecretPassword1/)' }
]


resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location

  kind: 'app'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
      appCommandLine: appCommandLine
      appSettings: appSettings
    }
  }
}

output appServiceAppHostName string = appServiceApp.properties.defaultHostName
