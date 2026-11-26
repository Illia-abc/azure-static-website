# Azure Portal — why it is done this way

Explanations for the steps in the [main README](../README.md#deployment-using-azure-portal).

---

## Why these settings

| Choice                          | Why                                                                                     |
| ------------------------------- | --------------------------------------------------------------------------------------- |
| Resource group first            | Every Azure resource must live in a group. One group = one place to delete everything   |
| Tags (`project`, `owner`, ...)  | Make resources easy to find, filter and track in billing                                |
| Storage account, not a VM       | Static files need no server. Storage is cheaper and has nothing to maintain             |
| `Standard` performance          | Premium is for low-latency workloads, a simple site does not need it                    |
| `LRS` redundancy                | Cheapest option. Data is copied inside one datacenter, enough for a pet project         |
| Default values on other tabs    | Networking, encryption and protection defaults are safe for a learning project          |
| Static website feature          | Gives a public HTTPS endpoint and serves `index.html` automatically                     |
| Index + error document          | Defines the main page and the custom page for non-existing addresses                    |
| Files in the root of `$web`     | The site uses absolute paths such as `/style.css`, so subfolders would break the styles |
| Storage account name            | Must be globally unique, 3–24 lowercase letters and digits                              |

---

## Portal vs Bicep vs Terraform

| Aspect              | Portal                              | Bicep                                    | Terraform                              |
| ------------------- | ----------------------------------- | ---------------------------------------- | -------------------------------------- |
| First deployment    | Fastest, nothing to learn           | Template has to be written               | Configuration has to be written        |
| Repeatability       | Manual clicks every time            | One command                              | One command                            |
| Risk of human error | Higher (typos, forgotten tags)      | Lower, values are in files               | Lower, values are in files             |
| Version control     | Only screenshots and README         | Template stored in Git                   | Configuration stored in Git            |
| Preview of changes  | None                                | `what-if`                                | `terraform plan`                       |
| Works with          | Azure                               | Azure only                               | Many clouds                            |
| Uploads site files  | Manually                            | Separate Azure CLI step                  | Same configuration                     |
| State               | Azure itself                        | Azure itself                             | Local state file (`terraform.tfstate`) |

---

## Troubleshooting

| Problem                                               | Solution                                                         |
| ----------------------------------------------------- | ---------------------------------------------------------------- |
| Storage account name is not accepted                  | Use 3–24 lowercase letters and digits, and make it unique        |
| `$web` container is missing                           | Static website is not enabled yet. Enable it and click **Save**  |
| Endpoint shows "The requested content does not exist" | `index.html` is not in the root of `$web`, or the name differs   |
| Page opens without styles                             | `style.css` was not uploaded, or it is in a subfolder            |
| Changes do not appear                                 | Re-upload with overwrite enabled, wait a minute, hard refresh    |
| Unexpected charges                                    | Check that Defender for Storage is off, or delete the group      |

---

## What I learned

- Creating Azure Resource Groups and Storage Accounts
- Using tags to organize resources
- Understanding basic Azure Storage configuration
- Enabling Static Website hosting
- Working with Blob containers and uploading files
- Finding and testing Azure endpoints
- Managing Azure resources through the Azure Portal
