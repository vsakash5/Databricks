# Databricks Unity Catalog Deployment with Terraform & Azure DevOps

## Overview

This repository contains all the Terraform code, modules, and Azure DevOps pipeline configurations needed to deploy and manage Databricks infrastructure, Unity Catalog data assets, and external locations on Azure. The deployment process is automated using Azure DevOps pipelines for consistent, repeatable infrastructure as code.

---

## Table of Contents

- Prerequisites
- Architecture
- Folder Structure
- Setup
- Workflow
- Authentication

---

## Prerequisites

Before you begin, ensure you have:

- Terraform (https://learn.microsoft.com/en-us/azure/developer/terraform/install-configure)
- Azure CLI (https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Access to an Azure subscription
- Azure DevOps project with agent pool
- Service Principal with Contributor access
- Azure Key Vault for secret management

---

## Architecture

The solution provisions and manages:

- Databricks instance pools and shared clusters
- Secret scopes integrated with Azure Key Vault
- Unity Catalog catalogs, schemas, and volumes
- External locations and storage credentials for Unity Catalog
- Fine-grained access control via grants
- Remote Terraform state in Azure Storage

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
## Setup

1. **Clone this repository:**
   ```sh
   git clone https://github.com/{your-org}/databricks-terraform-azuredevops
   cd databricks-terraform-azuredevops

2. Create and configure Azure resources:

   Azure Key Vault (for secrets)
   Azure Storage Account (for Terraform state)
   Databricks Workspace(s)
   Managed Identity Access Connector(s)

3. Set up Azure DevOps:

   Create a Service Connection for Azure
   Link Key Vault secrets to your pipeline library
   Configure agent pools

4. Configure environment variables and secrets:

   Store Service Principal credentials and Databricks host in Key Vault:
   Databricks-ARM-ClientId
   Databricks-ARM-ClientSecret
   DATABRICKS-HOST
Reference these in your pipeline templates
---

Workflow
1. Manual Deployment
2. CI/CD Pipeline Deployment
   Pipelines are defined in Pipelines/
   Each pipeline supports plan/apply for both dev and prd environments
   Secrets are fetched from Key Vault and set as environment variables for Terraform
   Artifacts are built and published, then consumed by deployment jobs
   
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


Authentication-Related Files
   databricks-infra/dev/dev.tfvars:
   Contains environment-specific Azure and Databricks identifiers, including az_subscription_id, tenant_id,      databricks_workspace_name, databricks_workspace_host, key_vault_name, and scope_name.
   
   databricks-infra/main.tf:
   Configures the AzureRM and Databricks providers using variables and environment variables injected by the     pipeline.
   
   modules/infra-assets/main.tf:
   Creates Databricks secret scopes linked to Azure Key Vault.
   
   Pipelines/Templates/databricks-infra-plan-template.yaml:
   Fetches secrets from Key Vault and sets them as environment variables for Terraform.
   
   databricks-infra/dev/dev_backend.conf:
   Configures remote backend for Terraform state in Azure Storage.
   
   databricks-uc-data-assets/main.tf and
   databricks-uc-external-locations/main.tf:
   Use the same authentication mechanism for Databricks and Azure.

## References

- [Authenticate Terraform to Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure)
- [Configure Databricks Terraform Provider Authentication](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/terraform/authentication)
- [Integrate Azure Key Vault with Azure Databricks](https://learn.microsoft.com/en-us/azure/databricks/security/secrets/secret-scopes)
- [Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)
- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Databricks Terraform Provider Docs](https://registry.terraform.io/providers/databricks/databricks/latest/docs)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/?view=azure-devops)


