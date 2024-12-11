param location string = resourceGroup().location
param name string
param appServicePlanId string
param dockerRegistryName string
@secure()
param dockerRegistryServerPassword string
@secure()
param dockerRegistryServerUserName string
param dockerRegistryImageName string
param dockerRegistryImageVersion string = 'latest'
param appCommandLine string = ''
resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
name: name
location: location


kind: 'app'
properties: {
// severFarmResourceId: resourceId('Microsoft.Web/serverfarms', appServicePlanName)
serverFarmId: appServicePlanId
siteConfig: {
  linuxFxVersion: 'DOCKER|${dockerRegistryName}.azurecr.io/${dockerRegistryImageName}:${dockerRegistryImageVersion}'
  appCommandLine: appCommandLine
  appSettings: [
    { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'false' }
    { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${dockerRegistryName}.azurecr.io' }
    { name: 'DOCKER_REGISTRY_SERVER_USERNAME', value: dockerRegistryServerUserName}
    { name: 'DOCKER_REGISTRY_SERVER_PASSWORD', value: dockerRegistryServerPassword}]
    
}

}
}
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
