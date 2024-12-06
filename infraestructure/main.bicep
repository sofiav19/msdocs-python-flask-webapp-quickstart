param location string
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param appServicePlanName string
param webAppName string

// Deploy Azure Container Registry
module acr 'modules/acr.bicep' = {
  name: 'acrDeployment'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: true
  }
}

// Deploy Azure App Service Plan
module appServicePlan 'modules/app-service-plan.bicep' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
      reserved: true
    }
  }
}

// Deploy Azure Web App
module webApp 'modules/web-app.bicep' = {
  name: 'webAppDeployment'
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: acr.outputs.loginServer
      DOCKER_REGISTRY_SERVER_USERNAME: acr.outputs.adminUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: acr.outputs.adminPassword
    }
  }
}
