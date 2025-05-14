# Deploy Azure Databricks using Terraform and Azure Devops pipeline

This repository demonstrates a modular approach to deploying Databricks infrastructure, Unity Catalog data assets, and external locations using **Terraform**, orchestrated via **Azure DevOps Pipelines** on **Azure**.

---

## Table of Contents

- [Overview](#overview)
- [Folder Structure](#folder-structure)
- [Process Details](#process-details)
- [Authentication](#authentication)
- [Authentication-Related Files](#authentication-related-files)
- [Required Details for Successful Deployment](#required-details-for-successful-deployment)
- [How to Deploy](#how-to-deploy)
- [Additional Notes](#additional-notes)
- [References](#references)



![image](https://github.com/user-attachments/assets/2f2c137d-3328-41b9-8c08-ef2878b05fa4)



## Overview

The codebase is organized to support the following processes:

1. **Databricks Infrastructure Provisioning**
   - Instance pools
   - Shared clusters
   - Secret scopes (integrated with Azure Key Vault)

2. **Unity Catalog Data Assets Deployment**
   - Catalogs, schemas, and volumes
   - Catalog and schema permissions

3. **External Locations Management**
   - Creation of external locations for Unity Catalog
   - Storage credential management and permissions

4. **CI/CD Automation**
   - Azure DevOps YAML pipelines for plan/apply workflows
   - Environment-specific deployments (dev, prd)

---

## Folder Structure

```
Azure Databricks/
├── architecture-diagram.drawio
├── readme.md
├── databricks-infra/                # Infra: pools, clusters, secret scopes
│   ├── main.tf
│   ├── variables.tf
│   ├── dev/
│   └── prd/
├── databricks-uc-data-assets/       # Unity Catalog: catalogs, schemas, volumes
│   ├── main.tf
│   ├── variables.tf
│   ├── dev/
│   └── prd/
├── databricks-uc-external-locations/# External locations, storage credentials
│   ├── main.tf
│   ├── variables.tf
│   ├── dev/
│   └── prd/
├── modules/                         # Reusable Terraform modules
│   ├── infra-assets/
│   ├── uc-data-assets/
│   └── uc-external-locations/
└── Pipelines/                       # Azure DevOps YAML pipelines & templates
    ├── databricks-infra-deploy-main.yaml
    ├── databricks-unity-catalog-deploy-main.yaml
    ├── databricks-external-locations-deploy-main.yaml
    └── Templates/
```

---

## Process Details

### 1. Infrastructure Provisioning

- **Instance Pools:** Defined in `instance_pools` variable, created via [`modules/infra-assets`](Azure%20Databricks/modules/infra-assets).
- **Shared Clusters:** Configured in `databricks_shared_clusters` variable, supporting autoscaling, node types, and security modes.
- **Secret Scopes:** Integrated with Azure Key Vault for secure secret management.

### 2. Unity Catalog Data Assets

- **Catalogs:** Created for different purposes (e.g., `sa`, `cdh`, `ws`) with specific owners, storage roots, and grants.
- **Schemas & Volumes:** Defined per catalog, supporting custom properties, storage locations, and fine-grained permissions.

### 3. External Locations

- **Storage Credentials:** Managed via Azure Managed Identity Access Connectors.
- **External Locations:** Configured for each data layer (catalog, bronze, silver, gold, landing zones, etc.), with read/write and validation options.
- **Grants:** Fine-grained access control for each external location.

### 4. CI/CD Automation

- **Pipelines:** YAML files in [`Pipelines`](Azure%20Databricks/Pipelines) automate plan/apply for each environment and component.
- **Templates:** Reusable pipeline templates for artifacts, plan, and apply stages.
- **Artifact Management:** Build artifacts are published and consumed by deployment jobs.

---

## Connection Mechanism

Authentication

Authentication is handled securely and automatically via Azure DevOps and Key Vault:

1. AzureRM Provider Authentication

Purpose: Allows Terraform to provision resources in your Azure subscription.

How:

    Uses Service Principal credentials (ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID)     fetched from Azure Key Vault.
    These are injected as environment variables in the pipeline and referenced in provider blocks.
    See databricks-infra/main.tf and Pipelines/Templates/databricks-infra-plan-template.yaml.

2. Databricks Provider Authentication
   
Purpose: Allows Terraform to manage Databricks resources (clusters, pools, Unity Catalog, etc.) in your workspace.

How:

    Uses the Databricks workspace host and Azure resource ID (constructed from variables in dev.tfvars).
    Authenticates via the same Service Principal, leveraging Azure AD integration.
    See databricks-infra/main.tf, databricks-uc-data-assets/main.tf, and databricks-uc-external-                  locations/main.tf.

3. Key Vault Integration
   
Purpose: Securely manage secrets (like passwords, keys) for Databricks secret scopes.

How:

    Secret scopes in Databricks are linked to Azure Key Vault for secure secret management.
    key_vault_name, scope_name, and key_vault_resource_group are used to configure this linkage in Terraform modules.
    See modules/infra-assets/main.tf.

4. Remote State
   
Purpose: Store Terraform state securely in Azure Storage.

How:

    Defined in backend config files such as dev_backend.conf and prd_backend.conf in each environment folder.
    See databricks-infra/dev/dev_backend.conf.

5. Pipeline Secret Management
   
Purpose: Automate the secure injection of credentials into pipeline jobs.

How:

    Azure DevOps tasks fetch secrets from Azure Key Vault at runtime.
    Secrets are set as environment variables for Terraform commands.
    See Pipelines/Templates/databricks-infra-plan-template.yaml and similar templates.

Here’s your updated `README.md` file with bullet points for each file description, making it easier to read and navigate:

📄 **[Download Updated README.md](blob:https://m365.cloud.microsoft/7c2863b9-eb67-4c07-84b4-e64320b37668)**

---

# Authentication-Related Files

## Files and Descriptions

- **`databricks-infra/{$env}/{$env}.tfvars`**
  - Contains environment-specific Azure and Databricks identifiers, including:
    - `az_subscription_id`
    - `tenant_id`
    - `databricks_workspace_name`
    - `databricks_workspace_host`
    - `key_vault_name`
    - `scope_name`

- **`databricks-infra/main.tf`**
  - Configures the AzureRM and Databricks providers using variables and environment variables injected by the pipeline.

- **`modules/infra-assets/main.tf`**
  - Creates Databricks secret scopes linked to Azure Key Vault.

- **`Pipelines/Templates/databricks-infra-plan-template.yaml`**
  - Fetches secrets from Key Vault and sets them as environment variables for Terraform.

- **`databricks-infra/dev/dev_backend.conf`**
  - Configures remote backend for Terraform state in Azure Storage.

- **`databricks-uc-data-assets/main.tf`**
  - Uses the same authentication mechanism for Databricks and Azure.

- **`databricks-uc-external-locations/main.tf`**
  - Uses the same authentication mechanism for Databricks and Azure.

---

### Databricks Workspace

- **Workspace Host:** Provided via `databricks_workspace_host` variable.
- **Workspace Resource ID:** Constructed from subscription, resource group, and workspace name.
- **Provider Aliasing:** Ensures correct context for Databricks API calls.

### Remote State

- **Terraform State:** Stored in Azure Storage Account, configured via `<env>/<env>_backend.conf` files.

---

## Required Details for Successful Deployment

1. **Azure Subscription ID:** For resource provisioning.
2. **Resource Group:** Where Databricks and supporting resources reside.
3. **Databricks Workspace Name & Host:** For API and provider configuration.
4. **Tenant ID:** Azure Active Directory tenant for authentication.
5. **Access Connector Name:** For managed identity storage credentials.
6. **Key Vault Name & Resource Group:** For secret scope integration.
7. **Storage Account Names:** For each data layer (catalog, bronze, silver, gold, landing, etc.).
8. **Metastore ID:** For Unity Catalog operations.
9. **Owners and Grants:** Email addresses or group names for resource ownership and permissions.
10. **Pipeline Service Connection:** Azure DevOps service connection with sufficient permissions.

---

## How to Deploy

### 1. Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Azure DevOps project with pipeline agent pool
- Service Principal with contributor access
- Azure Key Vault with required secrets

### 2. Configure Environment

- Edit the relevant `dev.tfvars` or `prd.tfvars` files with your environment details.
- Ensure backend config files (`dev_backend.conf`, `prd_backend.conf`) point to the correct storage account and container.

### 3. Run Pipelines

- Trigger the desired pipeline in Azure DevOps (plan/apply for dev or prd).
- Pipelines will:
  - Download artifacts
  - Fetch secrets from Key Vault
  - Run `terraform init`, `plan`, and `apply` for each component

### 4. Manual Terraform (Optional)

You can also run Terraform manually:

```sh
az login

export ARM_ACCESS_KEY=<your_storage_account_key>

terraform init -backend-config="dev/dev_backend.conf" -reconfigure

terraform plan -var-file="dev/dev.tfvars" -out=plan/dev_plan

terraform apply "plan/dev_plan"
```

---

## Additional Notes

- **State Migration:** Always migrate any existing state before generating or applying a plan to avoid resource conflicts or unintentional deletions.
- **Modularity:** Each major component (infra, data assets, external locations) is modular and can be deployed independently.
- **Security:** All sensitive values are managed via Azure Key Vault and not hardcoded.

---

## References

- [Authenticate Terraform to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure)
- [Configure Databricks Terraform Provider Authentication](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/terraform/authentication)
- [Integrate Azure Key Vault with Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/security/secrets/secret-scopes)
- [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Databricks Terraform Provider Docs](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)
