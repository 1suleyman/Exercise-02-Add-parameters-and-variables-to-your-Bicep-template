param location string = 'westus' // Default location for resources
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}' // Unique name for the storage account
param appServiceAppName string = 'toylaunchapp${uniqueString(resourceGroup().id)}' // Unique name for the app service

@allowed([ 
  'nonprod'
  'prod'
])
param environmentType string // Environment type for the deployment

var appServicePlanName = 'toy-product-launch-plan' 
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
