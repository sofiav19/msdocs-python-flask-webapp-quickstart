param name string = 'sofia-kv1'
param location string = resourceGroup().location
param enableVaultForDeployment bool = false
param principalId string = '25d8d697-c4a2-479f-96e0-15593a830ae5'

  resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
    name: name
    location: location
    properties: {
      enabledForDeployment: enableVaultForDeployment
      enabledForTemplateDeployment: true
      enableRbacAuthorization: true
      enableSoftDelete: true // Best practice to keep this enabled
      sku: {
        family: 'A'
        name: 'standard'
      }
      tenantId: subscription().tenantId
      accessPolicies: [] // Using RBAC, no direct access policies required
    }
  }

  resource keyVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
    name: guid(keyVault.id, principalId, 'Key Vault Secrets User')
    scope: keyVault
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6') // Key Vault Secrets User role
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }
  output keyVaultId string = keyVault.id
