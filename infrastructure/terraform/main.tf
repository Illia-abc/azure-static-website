terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.14.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

locals {
  site_files = {
    "index.html" = "text/html"
    "style.css"  = "text/css"
    "404.html"   = "text/html"
  }

  storage_account_name = "stweb${random_string.suffix.result}"

  tags = {
    project     = "static-azure-website"
    owner       = "illia"
    environment = var.environment
    deployment  = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "main-storage" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "azurerm_storage_account_static_website" "main" {
  storage_account_id = azurerm_storage_account.main-storage.id
  index_document     = "index.html"
  error_404_document = "404.html"
}

resource "azurerm_storage_blob" "site" {
  for_each = local.site_files

  name                 = each.key
  storage_container_id = "${azurerm_storage_account_static_website.main.storage_account_id}/blobServices/default/containers/$web"
  type                 = "Block"
  content_type         = each.value
  source               = "${path.module}/../../src/${each.key}"
  content_md5          = filemd5("${path.module}/../../src/${each.key}")
}