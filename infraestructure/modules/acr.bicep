param name string
param location string = resourceGroup().location
param keyVaultId string

// Azure Container Registry resource
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

// Reference existing Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: last(split(keyVaultId, '/')) 
}


// Create a secret to store the container registry admin username
resource secretkeyvaultId 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'adminCredentialsKeyVaultResourceId'
  parent: keyVault
  properties: {
    value: containerRegistry.id
  }
}

// Create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'adminCredentialsKeyVaultSecretUserName'
  parent: keyVault
  properties: {
    value: containerRegistry.listCredentials().username
  }
}

// Create a secret to store the container registry admin password 1
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'adminCredentialsKeyVaultSecretUserPassword1'
  parent: keyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
  }
}

// Create a secret to store the container registry admin password 2
resource secretAdminUserPassword2 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: 'adminCredentialsKeyVaultSecretUserPassword2'
  parent: keyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
  }
}
