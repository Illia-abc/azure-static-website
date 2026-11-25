output "website_url" {
    description = "The URL of the static website"
    value = azurerm_storage_account.main-storage.primary_web_endpoint
 }

 output "storage_account_name" {
    description = "The name of the storage account"
    value = azurerm_storage_account.main-storage.name
 }

 output "resource_group_name" {
    description = "The name of the resource group"
    value = azurerm_resource_group.rg.name
 }