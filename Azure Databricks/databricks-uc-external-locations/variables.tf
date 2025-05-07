variable "az_subscription_id" {
  description = "Azure subscription ID to use used"
}

variable "environment" {
  description = "Environment to deploy the resources to"
  default     = "dev"
  // Allowed values: dev, pro
  validation {
    condition     = var.environment == "dev" || var.environment == "prd"
    error_message = "Invalid environment. Allowed values are dev, prd"
  }
}

variable "databricks_workspace_host" {
  description = "Url of the databricks workspace"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Name of the databricks workspace"
  type        = string
}

variable "databricks_access_connector_name" {
  description = "Name of the databricks access connector"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "catalog_storage_account_name" {
  description = "Storage account for catalog root storage"
  type        = string
}

variable "bronze_storage_account_name" {
  description = "Storage account for bronze layer"
  type        = string
}

variable "silver_storage_account_name" {
  description = "Storage account for silver layer"
  type        = string
}

variable "gold_storage_account_name" {
  description = "Storage account for gold layer"
  type        = string
}

variable "checkpoint_storage_account_name" {
  description = "Storage account for spark checkpoint storage"
  type        = string
}

variable "landing_1_storage_account_name" {
  description = "Storage account for landing 1"
  type        = string
}

variable "landing_2_storage_account_name" {
  description = "Storage account for landing 2"
  type        = string
}

variable "landing_3_storage_account_name" {
  description = "Storage account for landing 3"
  type        = string
}

variable "aggregations_storage_account_name" {
  description = "Storage account for aggregations"
  type        = string
}

variable "cdh_storage_account_name" {
  description = "Storage account for cdh storage"
  type        = string
}

variable "workspace_storage_account_name" {
  description = "Storage account for workspace storage"
  type        = string
}

variable "catalog_grants" {
  description = "Grants for the catalog external location"
  type        = map(list(string))
}

variable "bronze_grants" {
  description = "Grants for the bronze external location"
  type        = map(list(string))
}

variable "silver_grants" {
  description = "Grants for the silver external location"
  type        = map(list(string))
}

variable "gold_grants" {
  description = "Grants for the gold external location"
  type        = map(list(string))
}

variable "bronze_checkpoints_grants" {
  description = "Grants for the bronze checkpoints external location"
  type        = map(list(string))
}

variable "silver_checkpoints_grants" {
  description = "Grants for the silver checkpoints external location"
  type        = map(list(string))
}

variable "gold_checkpoints_grants" {
  description = "Grants for the gold checkpoints external location"
  type        = map(list(string))
}

variable "landingzone_1_grants" {
  description = "Grants for the first landing zone external location"
  type        = map(list(string))
}

variable "landingzone_2_grants" {
  description = "Grants for the second landing zone external location"
  type        = map(list(string))
}

variable "landingzone_3_grants" {
  description = "Grants for the third landing zone external location"
  type        = map(list(string))
}

variable "aggregations_grants" {
  description = "Grants for the aggregations external location"
  type        = map(list(string))
}

variable "workspace_grants" {
  description = "Grants for the workspace external location"
  type        = map(list(string))
}

variable "cdh_catalog_grants" {
  description = "Grants for the CDH catalog external location"
  type        = map(list(string))
}

variable "cdh_data_grants" {
  description = "Grants for the CDH data external location"
  type        = map(list(string))
}

variable "owner" {
  type = string
}

variable "storage_cred_grants" {
  description = "Grants for storage credentials"
  type        = map(list(string))
}

variable "sparkaggregationfiles_storage_account_name" {
  type = string
}

variable "sparkaggregationfiles_grants" {
  description = "Grants for sparkaggregationfiles"
  type        = map(list(string))
}