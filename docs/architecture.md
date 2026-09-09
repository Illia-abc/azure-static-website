# Architecture

## Overview

This project hosts a static website using an Azure Storage Account with the Static Website hosting feature enabled. All infrastructure is provisioned using Bicep, Azure's native Infrastructure as Code (IaC) language.

## High-Level Flow

User
↓
Azure Storage Account
↓
Static Website hosting ($web container)
↓
index.html / style.css


A user requests the site URL. Azure Storage serves the static files (`index.html`, `style.css`) directly from a special container named `$web`, without any dedicated web server or compute resource involved.

## Why Azure Storage Account?

Azure Storage Account with Static Website hosting is one of the simplest and cheapest ways to host a static site in Azure. It requires no virtual machines, no App Service plan, and no server management — the Storage Account itself serves HTTP(S) content directly from blob storage.

This makes it a good fit for:
- Simple static sites (HTML/CSS/JS, no backend)
- Portfolio pages, documentation sites, landing pages
- Learning core Azure and IaC concepts without unnecessary complexity

## Bicep

### What is Bicep?

Bicep is a domain-specific language (DSL) developed by Microsoft for defining Azure resources declaratively. Instead of manually creating resources through the Azure Portal, Bicep lets you describe the desired end state of your infrastructure in code, which Azure then provisions automatically.

Bicep compiles down to ARM (Azure Resource Manager) templates, but with much simpler and more readable syntax.

Benefits of using Bicep here:
- **Repeatability** — the same template can recreate identical infrastructure at any time
- **Version control** — infrastructure changes are tracked in Git, just like application code
- **No manual clicking** — reduces human error compared to configuring resources through the Portal

### Control Plane vs Data Plane

An important distinction in this project:

- **Control plane** (managed by Bicep/ARM) — creating the Storage Account itself, setting its SKU, region, and access properties.
- **Data plane** (managed via Azure CLI, separately from Bicep) — enabling the actual Static Website feature and uploading blob content into the `$web` container.

This is why the deployment process has two steps: first Bicep provisions the Storage Account, then a separate Azure CLI command enables static website hosting and uploads the site files. Bicep does not currently support configuring static website settings directly, since this is a data-plane operation rather than a resource-manager operation.

### Deployment Process

1. **Bicep template execution** — `az deployment group create` reads `infrastructure/main.bicep` and provisions a Storage Account in the target resource group.
2. **Enable static website hosting** — a separate Azure CLI command (`az storage blob service-properties update`) turns on the static website feature and sets `index.html` as the default document.
3. **Upload website files** — `az storage blob upload-batch` uploads the contents of `src/` into the `$web` container.
4. **Access the site** — Azure exposes a public HTTPS endpoint (e.g. `https://<account>.z13.web.core.windows.net/`) where the site becomes available.

### Resources Provisioned

| Resource                        | Purpose                                              |
|----------------------------------|-------------------------------------------------------|
| Storage Account (`StorageV2`)   | Hosts static website files and serves them over HTTPS |

## Terraform

*(To be added)*

## Portal

*(To be added)*