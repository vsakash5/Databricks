terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.111.0"
    }

    databricks = {
      source                = "databricks/databricks"
      version               = ">=1.48.2"
      configuration_aliases = [databricks.workspace]
    }
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  subscription_id = var.az_subscription_id
  tenant_id       = var.tenant_id
  features {}
}

provider "databricks" {
  alias                       = "workspace"
  host                        = var.databricks_workspace_host
  azure_workspace_resource_id = local.databricks_workspace_resource_name
  azure_tenant_id             = var.tenant_id
}

locals {
  databricks_workspace_resource_name = "/subscriptions/${var.az_subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Databricks/workspaces/${var.databricks_workspace_name}"
}


module "databricks_infra_assets" {
  source = "../modules/infra-assets"
    az_subscription_id = var.az_subscription_id
    databricks_workspace_name = var.databricks_workspace_name
    resource_group = var.resource_group
    instance_pools = var.instance_pools
    tenant_id = var.tenant_id
    environment = var.environment
    key_vault_name = var.key_vault_name
    scope_name = var.scope_name
    key_vault_resource_group = var.key_vault_resource_group
    databricks_shared_clusters = var.databricks_shared_clusters
    # databricks_shared_cluster_name = var.databricks_shared_cluster_name
    # databricks_shared_cluster_spark_version = var.databricks_shared_cluster_spark_version
    # databricks_shared_cluster_node_type_id = var.databricks_shared_cluster_node_type_id
    # databricks_shared_cluster_custom_tags = var.databricks_shared_cluster_custom_tags
    # databricks_shared_cluster_data_security_mode = var.databricks_shared_cluster_data_security_mode
    # databricks_shared_cluster_azure_attributes = var.databricks_shared_cluster_azure_attributes
}