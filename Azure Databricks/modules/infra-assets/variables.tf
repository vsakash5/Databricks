variable "az_subscription_id" {
  description = "Azure subscription ID to use"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Name of the databricks workspace"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "tenant_id" {
  type        = string
  description = "Tenant ID"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "instance_pools" {
  type        = map(object({
    instance_pool_name                  = string
    min_idle_instances                  = number
    node_type_id                        = string
    max_capacity                        = number
    idle_instance_autotermination_minutes = number
    custom_tags                         = map(string)
    preloaded_spark_versions            = list(string)
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

variable "databricks_shared_clusters" {
  type        = map(object({
    databricks_shared_cluster_name     = string
    databricks_shared_cluster_node_type_id                       = string
    databricks_shared_cluster_driver_node_type_id                = string
    databricks_shared_cluster_spark_version                      = string
    databricks_shared_cluster_runtime_engine                     = string
    databricks_shared_cluster_custom_tags                        = map(string)
    databricks_shared_cluster_data_security_mode                 = string
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