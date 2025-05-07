# Databricks Terraform Deployment on Azure

This repository demonstrates a modular approach to deploying Databricks infrastructure, Unity Catalog data assets, and external locations using **Terraform**, orchestrated via **Azure DevOps Pipelines** on **Azure**.

---

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

- [`Azure Databricks/databricks-infra`](Azure%20Databricks/databricks-infra): Infra deployment (instance pools, clusters, secret scopes)
- [`Azure Databricks/databricks-uc-data-assets`](Azure%20Databricks/databricks-uc-data-assets): Unity Catalog catalogs, schemas, volumes
- [`Azure Databricks/databricks-uc-external-locations`](Azure%20Databricks/databricks-uc-external-locations): External locations and storage credentials
- [`Azure Databricks/modules`](Azure%20Databricks/modules): Reusable Terraform modules
- [`Azure Databricks/Pipelines`](Azure%20Databricks/Pipelines): Azure DevOps pipeline YAMLs and templates

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

### Azure Authentication

- **Terraform Providers:** Use AzureRM and Databricks providers.
- **Service Principal:** Azure DevOps pipelines fetch credentials (Client ID, Secret, Tenant ID, Subscription ID) from Azure Key Vault.
- **Environment Variables:** Set in pipeline steps for Terraform authentication (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`).

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

- [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- [Databricks Terraform Provider](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
- [AzureRM Terraform Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
