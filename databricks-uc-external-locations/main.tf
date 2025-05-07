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
  features {}
}

provider "databricks" {
  alias                       = "workspace"
  host                        = var.databricks_workspace_host
  azure_workspace_resource_id = local.databricks_workspace_resource_name
}

locals {
  databricks_workspace_resource_name = "/subscriptions/${var.az_subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Databricks/workspaces/${var.databricks_workspace_name}"
}

module "example_databricks_uc_external_locations" {
  source = "../modules/uc-external-locations"

  az_subscription_id        = var.az_subscription_id
  databricks_workspace_name = var.databricks_workspace_name
  resource_group            = var.resource_group
  access_connector_name     = var.databricks_access_connector_name
  storage_credential_owner  = var.owner
  storage_cred_grants       = var.storage_cred_grants
  external_locations = {
    "catalog" = {
      name                      = "${var.environment}_catalog"
      owner                     = var.owner
      comment                   = "External location used by ${var.environment}_sa catalog as root storage"
      storage_account_name      = "${var.catalog_storage_account_name}"
      storage_account_container = "catalog"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.catalog_grants
    },
    "bronze" = {
      name                      = "${var.environment}_bronze"
      owner                     = var.owner
      comment                   = "External location used for the bronze layer of the ${var.environment} environment"
      storage_account_name      = "${var.bronze_storage_account_name}"
      storage_account_container = "bronze"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.bronze_grants
    },
    "silver" = {
      name                      = "${var.environment}_silver"
      owner                     = var.owner
      comment                   = "External location used for the silver layer of the ${var.environment} environment"
      storage_account_name      = "${var.silver_storage_account_name}"
      storage_account_container = "silver"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.silver_grants
    },
    "gold" = {
      name                      = "${var.environment}_gold"
      owner                     = var.owner
      comment                   = "External location used for the gold layer of the ${var.environment} environment"
      storage_account_name      = "${var.gold_storage_account_name}"
      storage_account_container = "gold"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.gold_grants
    },
    "bronze_checkpoints" = {
      name                      = "${var.environment}_bronze_checkpoints"
      owner                     = var.owner
      comment                   = "External location used for the bronze checkpoints of the ${var.environment} environment"
      storage_account_name      = "${var.checkpoint_storage_account_name}"
      storage_account_container = "bronze-checkpoints"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.bronze_checkpoints_grants
    },
    "silver_checkpoints" = {
      name                      = "${var.environment}_silver_checkpoints"
      owner                     = var.owner
      comment                   = "External location used for the silver checkpoints of the ${var.environment} environment"
      storage_account_name      = "${var.checkpoint_storage_account_name}"
      storage_account_container = "silver-checkpoints"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.silver_checkpoints_grants
    },
    "gold_checkpoints" = {
      name                      = "${var.environment}_gold_checkpoints"
      owner                     = var.owner
      comment                   = "External location used for the gold checkpoints of the ${var.environment} environment"
      storage_account_name      = "${var.checkpoint_storage_account_name}"
      storage_account_container = "gold-checkpoints"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.gold_checkpoints_grants
    },
    "landingzone_1" = {
      name                      = "${var.environment}_landingzone_1"
      owner                     = var.owner
      comment                   = "External location used for the first landing zone of the ${var.environment} environment"
      storage_account_name      = "${var.landing_1_storage_account_name}"
      storage_account_container = "landingzone"
      storage_path              = ""
      read_only                 = true
      skip_validation           = true
      grants                    = var.landingzone_1_grants
    },
    "landingzone_2" = {
      name                      = "${var.environment}_landingzone_2"
      owner                     = var.owner
      comment                   = "External location used for the second landing zone of the ${var.environment} environment"
      storage_account_name      = "${var.landing_2_storage_account_name}"
      storage_account_container = "landingzone"
      storage_path              = ""
      read_only                 = true
      skip_validation           = true
      grants                    = var.landingzone_2_grants
    },
    "landingzone_3" = {
      name                      = "${var.environment}_landingzone_3"
      owner                     = var.owner
      comment                   = "External location used for the third landing zone of the ${var.environment} environment"
      storage_account_name      = "${var.landing_3_storage_account_name}"
      storage_account_container = "landingzone"
      storage_path              = ""
      read_only                 = true
      skip_validation           = true
      grants                    = var.landingzone_3_grants
    },
    "aggregations" = {
      name                      = "${var.environment}_aggregations"
      owner                     = var.owner
      comment                   = "External location used for the aggregations of the ${var.environment} environment"
      storage_account_name      = "${var.aggregations_storage_account_name}"
      storage_account_container = "aggregations"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.aggregations_grants
    },
    "workspace" = {
      name                      = "${var.environment}_workspace"
      owner                     = var.owner
      comment                   = "External location used for the workspace of the ${var.environment} environment"
      storage_account_name      = "${var.workspace_storage_account_name}"
      storage_account_container = "workspace"
      storage_path              = ""
      read_only                 = false
      skip_validation           = false
      grants                    = var.workspace_grants
    },
    "cdh_catalog" = {
      name                      = "${var.environment}_cdh_catalog"
      owner                     = var.owner
      comment                   = "External location used by ${var.environment}_cdh catalog as root storage"
      storage_account_name      = "${var.cdh_storage_account_name}"
      storage_account_container = "cdh"
      storage_path              = "unitycatalog"
      read_only                 = false
      skip_validation           = false
      grants                    = var.cdh_catalog_grants
    },
    "cdh_data" = {
      name                      = "${var.environment}_cdh_data"
      owner                     = var.owner
      comment                   = "External location used for the CDH data of the ${var.environment} environment"
      storage_account_name      = "${var.cdh_storage_account_name}"
      storage_account_container = "cdh"
      storage_path              = "drdata"
      read_only                 = true
      skip_validation           = true
      grants                    = var.cdh_data_grants
    },
    "sparkaggregationfiles" = {
      name                      = "${var.environment}_sparkaggregationfiles"
      owner                     = var.owner
      comment                   = "External location used by ${var.environment}_sa sparkaggregationfiles as root storage"
      storage_account_name      = "${var.sparkaggregationfiles_storage_account_name}"
      storage_account_container = "airflow-sql"
      storage_path              = "queries/AirflowSummaries/SparkAggregationFiles"
      read_only                 = false
      skip_validation           = true
      grants                    = var.sparkaggregationfiles_grants
    }

  }

  providers = {
    azurerm    = azurerm
    databricks = databricks.workspace
  }
}
