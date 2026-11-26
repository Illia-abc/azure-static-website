# Bicep — why it is done this way

Explanations for the steps in [README.md](README.md).

---

## Why these choices

| Choice                                   | Why                                                                                     |
| ---------------------------------------- | --------------------------------------------------------------------------------------- |
| Resource group created with Azure CLI    | A Bicep template at resource group scope needs an existing group                        |
| Values in `main.bicepparam`              | Template stays reusable, only the values change between deployments                     |
| Tags as one `object` parameter           | Tags can be changed in the parameters file without editing the template                 |
| `kind: 'StorageV2'`                      | Only this account type supports static website hosting                                  |
| `Standard_LRS`                           | Cheapest option, enough for a pet project                                               |
| `supportsHttpsTrafficOnly`               | Forces HTTPS                                                                            |
| `minimumTlsVersion: 'TLS1_2'`            | Blocks old, insecure TLS versions                                                       |
| `allowBlobPublicAccess: false`           | Containers are not anonymously readable directly, the site is served by the web endpoint |
| `what-if` before `create`                | Shows what Azure is going to change before anything is created                          |
| Role `Storage Blob Data Contributor`     | Creating the account does not give you access to its data. The CLI needs this role      |
| Static website enabled with Azure CLI    | It is a **data plane** setting, Bicep only manages the **control plane**                |
| `--auth-mode login`                      | Uses your Azure sign-in and the role instead of storage account keys                    |
| `'$web'` in single quotes                | PowerShell would treat `$web` as a variable otherwise                                   |
| Files in the root of `$web`              | The site uses absolute paths such as `/style.css`                                       |

---

## Control plane vs data plane

| Plane         | What it manages                         | Tool in this project |
| ------------- | --------------------------------------- | -------------------- |
| Control plane | Creating and configuring Azure resources | Bicep                |
| Data plane    | Data inside a resource (blobs, static website settings) | Azure CLI |

This is why Bicep alone cannot finish the deployment: it creates the storage account, but the site settings and file upload are done by the CLI.

---

## How the template works

| Part of `main.bicep`              | Purpose                                                        |
| --------------------------------- | -------------------------------------------------------------- |
| `param storageAccountName`        | Globally unique name, validated with `@minLength`/`@maxLength` |
| `param location`                  | Region, defaults to the resource group region                  |
| `param tags object = {}`          | All tags passed as one object, optional                        |
| `kind: 'StorageV2'`               | Account type that supports static website hosting              |
| `sku: Standard_LRS`               | Standard performance, locally redundant storage                |
| `output staticWebsiteUrl`         | Website address shown after deployment                         |

The `.bicepparam` file contains only values and starts with `using 'main.bicep'`, which links it to the template. Deployment functions such as `resourceGroup()` are available only in the template, not in the parameters file.

---

## Troubleshooting

| Problem                                              | Solution                                                                          |
| ---------------------------------------------------- | --------------------------------------------------------------------------------- |
| `StorageAccountAlreadyTaken`                         | The name is globally taken. Delete the old account or change `storageAccountName` |
| Red underline in `main.bicepparam`                   | Parameter name or type differs from `main.bicep`, or a deployment function was used |
| `AuthorizationPermissionMismatch` / 403 on CLI steps | Data role not assigned yet (Step 5). Wait a few minutes after assigning           |
| Resource group not found                             | Run Step 2 first, or check the `$RG` variable                                     |
| `$web` upload goes to the wrong place                | Use single quotes: `'$web'`                                                       |
| Site returns 404 on the main page                    | `index.html` is not in the root of `$web`                                         |
| Changes do not appear                                | Re-upload with `--overwrite`, wait a minute, hard refresh                         |
| Region not available for the subscription            | Choose another region in `main.bicepparam`                                        |

---

## What I learned

- Writing a Bicep template with parameters, decorators and outputs
- Separating values (`.bicepparam`) from the template (`.bicep`)
- Passing tags as a single object parameter
- Previewing changes with `what-if`
- The difference between the control plane and the data plane
- Why Azure role assignments are needed for data plane access
- Bicep compiles to ARM JSON, which does not need to be committed
