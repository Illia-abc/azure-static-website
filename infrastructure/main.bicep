// main.bicep
// Deploys an Azure Storage Account configured for static website hosting.

@description('Name of the storage account. Must be globally unique, lowercase, 3-24 chars, no dashes.')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Azure region where resources will be deployed.')
param location string = resourceGroup().location

@description('SKU for the storage account. LRS is cheapest and fine for a pet project.')
param storageSku string = 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountName string = storageAccount.name
output primaryEndpoint string = storageAccount.properties.primaryEndpoints.blob
