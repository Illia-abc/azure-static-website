# Azure Static Website

A simple static website deployed to Azure using Infrastructure as Code (Bicep).
This is a personal pet-project created to learn and demonstrate core Azure and DevOps skills: cloud hosting, Infrastructure as Code, and Git workflow.

## Overview

This project hosts a static HTML/CSS website directly from an Azure Storage Account, using its built-in Static Website hosting feature. All infrastructure is defined as code using Bicep instead of being manually created through the Azure Portal.

The goal of this project is to demonstrate:
- Basic Azure cloud services usage
- Infrastructure as Code (IaC) with Bicep
- A clean, well-structured Git repository and commit history

## Architecture

User
↓
Azure Storage Account
↓
Static Website hosting ($web container)
↓
index.html / style.css


The website files are served directly by Azure Storage's Static Website feature, without a dedicated web server — a cost-effective solution for simple static sites.

See [docs/architecture.md](docs/architecture.md) for a more detailed explanation.

## Azure Services

- **Azure Storage Account** — hosts the static website files and serves them over HTTPS
- **Static Website hosting** — a Storage Account feature that serves blob content as a public website

## Technologies

- HTML / CSS
- Azure Bicep (Infrastructure as Code)
- Azure CLI
- Git / GitHub

## Project Structure

azure-static-website/
│
├── src/
│ ├── index.html
│ └── style.css
│
├── infrastructure/
│ └── main.bicep
│
├── docs/
│ └── architecture.md
│
├── .gitignore
└── README.md


## Deployment

Infrastructure is deployed using Azure CLI and a Bicep template.

```bash
# Login to Azure
az login

# Create a resource group (if not already created)
az group create --name <resource-group-name> --location <region>

# Deploy the Bicep template
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file infrastructure/main.bicep \
  --parameters storageAccountName=<your-storage-account-name>

# Enable static website hosting on the storage account
az storage blob service-properties update \
  --account-name <your-storage-account-name> \
  --static-website \
  --index-document index.html \
  --404-document index.html

# Upload website files
az storage blob upload-batch \
  --account-name <your-storage-account-name> \
  -d '$web' \
  -s ./src
```

## How to Run

1. Clone the repository:
```bash
   git clone <repo-url>
```
2. Deploy the infrastructure and upload the files as described above.
3. Open the website URL shown in the Azure Portal (Storage Account → Static website → Primary endpoint).

## What I Learned

- How to define Azure infrastructure declaratively using Bicep
- The difference between control plane (ARM/Bicep) and data plane (Azure CLI) operations in Azure
- How Azure Storage's Static Website feature works
- Structuring a project and Git history in a clean, professional way