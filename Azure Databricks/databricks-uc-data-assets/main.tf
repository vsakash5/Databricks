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

module "sa_catalog" {
  source = "../modules/uc-data-assets"

  az_subscription_id        = var.az_subscription_id
  databricks_workspace_name = var.databricks_workspace_name
  resource_group            = var.resource_group
  metastore_id              = var.databricks_metastore_id
  catalog_name              = "${var.environment}_sa"
  catalog_owner             = var.catalog_owner
  catalog_comment           = "This catalog is for data assets"
  catalog_purpose           = "DEV"
  catalog_storage_root      = "abfss://catalog@${var.catalog_storage_account_name}.dfs.core.windows.net/" // or "" for internal
  catalog_grants = var.sa_catalog_grants
  schemas = var.schemas
  volumes = {
    "landing_zone_01": {
      schema           = "landing"
      volume_type      = "EXTERNAL"
      name             = "landing_zone_01"
      owner            = var.catalog_owner
      comment          = "This volume is for landing zone 01"
      storage_location = "abfss://landingzone@${var.landing_1_storage_account_name}.dfs.core.windows.net/ftp"
      grants = var.landing_grants_volumes
    },
    "landing_zone_02": {
      schema           = "landing"
      volume_type      = "EXTERNAL"
      name             = "landing_zone_02"
      owner            = var.catalog_owner
      comment          = "This volume is for landing zone 02"
      storage_location = "abfss://landingzone@${var.landing_2_storage_account_name}.dfs.core.windows.net/ftp"
      grants = var.landing_grants_volumes
    },
    "landing_zone_03": {
      schema           = "landing"
      volume_type      = "EXTERNAL"
      name             = "landing_zone_03"
      owner            = var.catalog_owner
      comment          = "This volume is for landing zone 03"
      storage_location = "abfss://landingzone@${var.landing_3_storage_account_name}.dfs.core.windows.net/ftp"
      grants = var.landing_grants_volumes
    }
  }

  providers = {
    azurerm    = azurerm
    databricks = databricks.workspace
  }
}

module "cdh_catalog" {
  source = "../modules/uc-data-assets"

  az_subscription_id        = var.az_subscription_id
  databricks_workspace_name = var.databricks_workspace_name
  resource_group            = var.resource_group
  metastore_id              = var.databricks_metastore_id
  catalog_name              = "${var.environment}_cdh"
  catalog_owner             = var.catalog_owner
  catalog_comment           = "Example comment"
  catalog_purpose           = "CDH"
  catalog_storage_root      = "abfss://cdh@${var.cdh_storage_account_name}.dfs.core.windows.net/unitycatalog" // or "" for internal
  catalog_grants            = var.cdh_catalog_grants
  schemas = {}

  volumes = {}

  providers = {
    azurerm    = azurerm
    databricks = databricks.workspace
  }
}

module "ws_catalog" {
  source = "../modules/uc-data-assets"

  az_subscription_id        = var.az_subscription_id
  databricks_workspace_name = var.databricks_workspace_name
  resource_group            = var.resource_group
  metastore_id              = var.databricks_metastore_id
  catalog_name              = "${var.environment}_ws"
  catalog_owner             = var.ws_catalog_owner
  catalog_comment           = "This catalog is for user workspaces"
  catalog_purpose           = "User Workspaces"
  catalog_storage_root      = "abfss://workspace@${var.workspace_storage_account_name}.dfs.core.windows.net/" // or "" for internal
  catalog_grants            = var.ws_catalog_grants
  schemas = var.ws_schemas

  volumes = {}

  providers = {
    azurerm    = azurerm
    databricks = databricks.workspace
  }
}

// TODO: Create sql foreign catalog