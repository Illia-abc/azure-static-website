# Azure Static Website

A simple static website deployed to Microsoft Azure using the Azure Portal.

The project was created as a practical exercise to learn Azure resource management, storage accounts, static website hosting, and basic cloud deployment workflows.

🔗 **Live demo:** `https://ststaticwebsite0129.z36.web.core.windows.net/`

![Deployed Website](docs/screenshots/08-website.png)

---

## Architecture

The project uses:

- **Azure Resource Group**
- **Azure Storage Account**
- **Static Website hosting**
- **Azure Blob Storage**
- **Azure Portal**

The website files are stored in the `$web` container provided by Azure Static Website hosting.

```text
Resource Group (rg-static-website)
└── Storage Account (ststaticwebsite0129)
    └── Static Website
        └── $web
            ├── index.html
            ├── style.css
            └── 404.html
```

---

## Project Structure

```text
azure-static-website/
│
├── src/
│   ├── index.html
│   └── style.css
│
├── docs/
│   └── screenshots/
│       ├── 01-resource-group.png
│       ├── 02-storage-account.png
│       ├── 03-storage-advanced.png
│       ├── 04-static-website.png
│       ├── 05-web-container.png
│       ├── 06-website-files.png
│       ├── 07-resources.png
│       └── 08-website.png
│
├── .gitignore
├── LICENSE
└── README.md
```

---

## Prerequisites

- An [Azure account](https://azure.microsoft.com/free/) (the free tier is enough)
- The website files from the `src/` folder

> Steps verified in October 2026. The Azure Portal UI may change slightly over time.

---

# Deployment using Azure Portal

Open the [Azure Portal](https://portal.azure.com/).

In the search bar, enter:

```text
Resource groups
```

Click **Resource groups → Create**.
Configure the resource group:

| Setting          | Value                     |
| ---------------- | ------------------------- |
| `Subscription`   | `Azure subscription 1`    |
| `Resource group` | `rg-static-website`       |
| `Region`         | `West Europe`             |

Open the **Tags** tab and add:

| Name          | Value            |
| ------------- | ---------------- |
| `project`     | `static-website` |
| `owner`       | `illia`          |
| `deployment`  | `portal`         |
| `purpose`     | `Pet-Project`    |
Click **Review + create**.

After validation completes, click **Create**.

![Azure Resource Group](docs/screenshots/01-resource-group.png)

---

# Step 2 — Create a Storage Account

In the Azure Portal search bar, search for:

```text
Storage accounts
```

Click **Storage account → Create**.

**Basics**
Configure the storage account:

| Settings                 | Value                                               |
| ------------------------ | --------------------------------------------------- |
| `Subscription`           | `Azure subscription 1`                              |
| `Resource group`         | `rg-static-website`                                 |
| `Storage account name`   | `ststaticwebsite0129`                               |
| `Region`                 | `poland central`                                    |
| `Preferred storage type` | `Azure Blob Storage or Azure Data Lake Storage Gen` |
| `Performance`            | `Standard`                                          |
| `Redundancy`             | `LRS(Locally-redundant storage `                    |

Open the **Tags** tab and add:

| Name          | Value            |
| ------------- | ---------------- |
| `project`     | `static-website` |
| `owner`       | `illia`          |
| `deployment`  | `portal`         |
| `purpose`     | `Pet-Project`    |

![Create Basics Settings for Storage Account](docs/screenshots/02-storage-account.png)

![Tags for Storage Account](docs/screenshots/03-storage-account-tags.png)

## Configure Another Settings

For this learning project, the default settings can be used for all another settings page.

Click **Review + create**.

After validation completes, click **Create**.

---

# Step 3 — Enable Static Website Hosting

Open the newly created Storage Account.

In the left menu, find:

```text
Data management
    → Static website
```

| Setting               | Value                     |
| --------------------- | ------------------------- |
| `Static website`      | `Enabled`                 |
| `Index document name` | `index.html`              |
| `Error document path` | `404.html`                |    

Click **Save**
Azure will automatically create a special blob container: 
```text
web
```
This container is used to store the static website files.

![Enable Static Website](docs/screenshots/04-static-website.png)

---

# Step 4 — Open the $web Container

In the Storage Account, go to:

```text
Data storage
    → Containers
```

Open:

```text
$web
```

The $web container is automatically created when Static Website hosting is enabled.

![\$web Container](docs/screenshots/05-web-container.png)

---

# Step 5 — Upload Website Files

Inside the $web container, click:

```text
Upload
```

Select the files from the website/ folder:

```text
index.html
style.css
404.html
```

Make sure that index.html is located in the root of the $web container, not inside a subfolder.

The final structure should look like this:

```text
$web/
│
├── index.html
├── style.css
└── 404.html
```

The site uses absolute paths such as /style.css, so the files must stay in the root of $web.

![Upload Website Files](docs/screenshots/06-website-files.png)

---

# Step 6 — Get the Website URL

Return to:

```text
Storage Account
    → Data management
    → Static website
```

Azure provides the Primary endpoint.

It will look similar to:

```text
https://ststaticwebsite0129.z36.web.core.windows.net/
```
![Deployed Azure Resources](docs/screenshots/07-resources.png)

---

# Step 7 — Verify the Deployment

Check the following:

- [x] Resource Group was created successfully
- [x] Storage Account was created successfully
- [x] Static Website was enabled
- [x] `$web` container was created
- [x] Website files were uploaded
- [x] `index.html` is in the root of `$web`
- [x] Primary endpoint opens successfully
- [x] HTTPS padlock is shown in the browser
- [x] Styles are applied (DevTools → Network → `style.css` returns `200`)

You can also check from a terminal:

```bash
curl -I https://ststaticwebsite0129.z36.web.core.windows.net/
```

Expected result:

```text
HTTP/1.1 200 OK
```

Finally, open **Resource Group → Overview** and confirm that the Storage Account is listed there.

![Deployed Website](docs/screenshots/08-website.png)
*Deployed Azure Resources*

---

# Step 8 — Update the Website

1. Edit the files in the `website/` folder.
2. Open `$web` in the Storage Account.
3. Click **Upload** and select the changed files.
4. Enable **Overwrite if files already exist**.
5. Hard refresh the browser (`Ctrl+Shift+R`).

---

# Step 9 — Clean Up (Optional)

To avoid unexpected charges, delete everything at once:

```text
Resource groups → rg-static-website → Delete resource group
```

Type the resource group name to confirm.

---

# Azure Resources

The final Azure environment contains:

```text
Resource Group
└── Storage Account
    └── Static Website
        └── $web
            ├── index.html
            ├── style.css
            └── 404.html
```

---

# Troubleshooting

| Problem                                               | Solution                                                                 |
| ----------------------------------------------------- | ------------------------------------------------------------------------ |
| Storage account name is not accepted                  | Use 3–24 lowercase letters and numbers only, and make it unique          |
| `$web` container is missing                           | Static website is not enabled yet, enable it and click **Save**          |
| Endpoint shows "The requested content does not exist" | `index.html` is not in the root of `$web`, or the name differs           |
| Page opens without styles                             | `style.css` was not uploaded, or it is in a subfolder                    |
| Changes do not appear                                 | Re-upload with overwrite enabled, wait a minute, hard refresh            |
| Unexpected charges                                    | Check that Defender for Storage is off, or delete the resource group     |

---

# What I Learned

This project helped me practice:

- Creating Azure Resource Groups
- Creating Azure Storage Accounts
- Using tags to organize resources
- Understanding Azure Storage configuration
- Enabling Static Website hosting
- Working with Blob Containers
- Uploading files to Azure
- Finding and testing Azure endpoints
- Managing Azure resources through the Azure Portal

---