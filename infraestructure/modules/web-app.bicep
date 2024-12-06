@description('Name of the Web App')
param name string

@description('Location of the Web App')
param location string

@description('Kind of the Web App')
param kind string

@description('App Service Plan resource ID')
param serverFarmResourceId string

@description('Site configuration')
param siteConfig object

@description('App settings key-value pairs')
param appSettingsKeyValuePairs object

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: '${webApp.name}/appsettings'
  properties: appSettingsKeyValuePairs
}

output webAppUrl string = webApp.properties.defaultHostName
