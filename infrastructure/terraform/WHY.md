# Terraform — why it is done this way

Explanations for the steps in [README.md](README.md).

---

## Why these choices

| Choice                                        | Why                                                                                          |
| --------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Terraform instead of Bicep + CLI              | One tool does infrastructure **and** file upload, no separate CLI steps                      |
| `random_string` suffix in the name            | Storage account names are globally unique. A random part avoids name conflicts               |
| `upper = false`, `special = false`            | Storage account names allow only lowercase letters and digits                                |
| `locals` for name, tags and files             | Values are defined once and reused, the resources stay short                                 |
| Tags in one `local.tags` object               | Same tags on every resource, changed in one place                                            |
| `azurerm_storage_account_static_website`      | Separate resource that enables static website and creates the `$web` container               |
| No `azurerm_storage_container` for `$web`     | Azure creates `$web` by itself. A manual container would conflict with it                    |
| `for_each` over `site_files`                  | One block uploads every file. A new file is one new line in the map                          |
| `each.key` / `each.value`                     | Key is the file name, value is its content type                                              |
| `content_type`                                | Without it Azure uses `application/octet-stream` and the browser downloads the page          |
| `content_md5 = filemd5(...)`                  | Terraform does not watch local files. The hash makes it re-upload a file when it changes     |
| `path.module` in `source`                     | The path works no matter where `terraform` is started from                                   |
| `storage_container_id` built from static website | Gives an implicit dependency, so files upload only after `$web` exists. No `depends_on` needed |
| `terraform.tfvars` not in Git                 | Contains the subscription ID. Git only has `terraform.tfvars.example`                        |
| `variables.tf` and `terraform.tfvars`         | The first **declares** variables, the second **sets** their values                           |
| `.terraform.lock.hcl` in Git                  | Everyone gets the same provider versions                                                     |
| `terraform.tfstate` not in Git                | State holds all resource details and must not be published                                   |
| `terraform plan` before `apply`               | Preview of changes, the equivalent of `what-if` in Bicep                                     |
| Pinned provider version                       | The code does not break after a provider update                                              |

---

## Resource and variable names

The name after the resource type (`rg`, `main-storage`, `main`) exists only inside Terraform. It never appears in Azure and is used to reference the resource:

```hcl
resource "azurerm_storage_account" "main-storage" { ... }
#         ^ type                     ^ local name

azurerm_storage_account.main-storage.name   # reference: type.name.attribute
```

---

## Terraform vs Bicep

| Aspect             | Bicep                         | Terraform                          |
| ------------------ | ----------------------------- | ---------------------------------- |
| Clouds             | Azure only                    | Many                               |
| Upload site files  | Separate Azure CLI step       | Same configuration                 |
| Enable static site | Separate Azure CLI step       | Resource in the configuration      |
| Role for data access | Needed for the CLI          | Not needed, Terraform uses the provider's access |
| State              | Azure itself                  | `terraform.tfstate` file           |
| Preview            | `what-if`                     | `terraform plan`                   |
| Delete             | Delete the resource group     | `terraform destroy`                |

---

## State file

Terraform remembers what it created in `terraform.tfstate`. It compares the code, the state and Azure to decide what to change.

- Never edit it by hand.
- Never commit it, it contains resource IDs and other details.
- If you delete it, Terraform forgets the resources and tries to create them again, so cleanup has to be done manually in Azure.

For a pet project a local state file is enough. In a team it is stored remotely (for example in an Azure Storage container).

---

## Troubleshooting

| Problem                                          | Solution                                                                               |
| ------------------------------------------------ | -------------------------------------------------------------------------------------- |
| `No configuration files`                         | Run the commands from `infrastructure/terraform/`, not from the repository root        |
| `Reference to undeclared resource`               | The resource type or name differs from its `resource "type" "name"` declaration        |
| `Unsupported attribute`                          | The attribute belongs to another resource, check which one exports it                  |
| `Unsupported argument` on `azurerm_storage_blob` | The provider version expects `storage_container_id` instead of the old parameters      |
| `terraform init` cannot find the provider version | Check the `version` in `required_providers` and run `terraform init -upgrade`         |
| Variable has no value / Terraform asks for input | `terraform.tfvars` is missing or in another folder                                     |
| Name conflict for the storage account            | Run `terraform apply` again, the random suffix is stored in the state                  |
| Site opens as a file download                    | `content_type` is missing or wrong for that file                                       |
| Changes in `src/` do not appear                  | `content_md5` is missing, or hard refresh the browser (`Ctrl+Shift+R`)                 |
| `$web` container already exists                  | Remove a manual `azurerm_storage_container` for `$web` from the configuration          |

---

## What I learned

- Describing Azure infrastructure with Terraform (providers, resources, variables, outputs)
- Difference between `variables.tf`, `terraform.tfvars` and `locals`
- Referencing resources and creating implicit dependencies
- Creating several similar resources with `for_each`
- Making Terraform detect file changes with `filemd5`
- Why state and variable files must not be committed
- Workflow `init` → `validate` → `plan` → `apply` → `destroy`
