using 'main.bicep'

param storageAccountName = 'ststaticwebsite0129'
param location = 'polandcentral'

param tags = {
  project: 'static-website'
  owner: 'illia'
  deployment: 'bicep'
  purpose: 'Pet-Project'
}
