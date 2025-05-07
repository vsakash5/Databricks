variable "az_subscription_id" {
  description = "Azure subscription ID to use used"
}

variable "tenant_id" {
  description = "Tenant ID of the Microsoft Entra ID tenant"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "environment" {
  description = "Environment to deploy the resources to"
  default     = "dev"
  // Allowed values: dev, tst, uat, pro
  validation {
    condition     = var.environment == "dev" || var.environment == "tst" || var.environment == "uat" || var.environment == "prd"
    error_message = "Invalid environment. Allowed values are dev, tst, uat, prd"
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

variable "instance_pools" {
  type        = map(object({
    instance_pool_name                  = string
    min_idle_instances                  = number
    node_type_id                       = string
    max_capacity                       = number
    idle_instance_autotermination_minutes = number
    custom_tags                        = map(string)
    preloaded_spark_versions           = list(string)
  }))
  description = "Map of instance pools to create"
}

variable "key_vault_name" {
  type        = string
  description = "Name of the key vault"
}

variable "scope_name" {
  type        = string
  description = "Name of the secret scope"
}

variable "key_vault_resource_group" {
  type        = string
  description = "Resource group of the key vault where scope is created"
}

# variable "databricks_shared_cluster_name" {
#   type        = string
#   description = "Name of the shared cluster"
# }

# variable "databricks_shared_cluster_spark_version" {
#   type        = string
#   description = "Spark version of the shared cluster"
# }

# variable "databricks_shared_cluster_node_type_id" {
#   type        = string
#   description = "Node type of the shared cluster"
# }

# variable "databricks_shared_cluster_custom_tags" {
#   type        = map(string)
#   description = "Custom tags for the shared cluster"
# }

# variable "databricks_shared_cluster_data_security_mode" {
#   type        = string
#   description = "Data security mode for the shared cluster"
# }

# variable "databricks_shared_cluster_azure_attributes" {
#   type        = object({
#     first_on_demand = number
#     availability = string
#     spot_bid_max_price = number
#   })
#   description = "Azure attributes for the shared cluster"
# }

variable "databricks_shared_clusters" {
  type        = map(object({
    databricks_shared_cluster_name     = string
    databricks_shared_cluster_node_type_id                       = string
    databricks_shared_cluster_driver_node_type_id                = string
    databricks_shared_cluster_spark_version                      = string
    databricks_shared_cluster_custom_tags                        = map(string)    
    databricks_shared_cluster_data_security_mode                 = string
    databricks_shared_cluster_runtime_engine                     = string
    databricks_shared_cluster_autotermination_minutes            = number
    databricks_shared_cluster_min_workers                        = number
    databricks_shared_cluster_max_workers                        = number
    databricks_shared_cluster_azure_attributes                   = object({
      first_on_demand                  = number
      availability                     = string
      spot_bid_max_price               = number
    })
  }))
  description = "Shared cluster configuration"
}