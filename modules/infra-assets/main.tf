// Create storage credentials, external locations, catalogs, schemas and grants
data "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group
}

locals {
  databricks_workspace_host          = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id            = data.azurerm_databricks_workspace.this.workspace_id
  databricks_workspace_resource_name = "/subscriptions/${var.az_subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Databricks/workspaces/${var.databricks_workspace_name}"
}

// Create the Pool
resource "databricks_instance_pool" "instance_pool" {
  for_each = var.instance_pools
  instance_pool_name  = each.value.instance_pool_name
  min_idle_instances = each.value.min_idle_instances
  node_type_id      = each.value.node_type_id
  max_capacity      = each.value.max_capacity
  idle_instance_autotermination_minutes = each.value.idle_instance_autotermination_minutes
  custom_tags = each.value.custom_tags
  preloaded_spark_versions = each.value.preloaded_spark_versions
}

data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

resource "databricks_secret_scope" "kvscope" {
  name = var.scope_name

  keyvault_metadata {
    resource_id = data.azurerm_key_vault.kv.id
    dns_name    = data.azurerm_key_vault.kv.vault_uri
  }
}

resource "databricks_cluster" "cluster" {
  for_each                = var.databricks_shared_clusters
  cluster_name            = each.value.databricks_shared_cluster_name
  spark_version           = each.value.databricks_shared_cluster_spark_version
  runtime_engine          = each.value.databricks_shared_cluster_runtime_engine
  node_type_id            = each.value.databricks_shared_cluster_node_type_id
  driver_node_type_id     = each.value.databricks_shared_cluster_driver_node_type_id
  autotermination_minutes = each.value.databricks_shared_cluster_autotermination_minutes
  autoscale {
    min_workers = each.value.databricks_shared_cluster_min_workers
    max_workers = each.value.databricks_shared_cluster_max_workers
  }
  custom_tags             = each.value.databricks_shared_cluster_custom_tags
  data_security_mode      = each.value.databricks_shared_cluster_data_security_mode
  azure_attributes        {
    first_on_demand     = each.value.databricks_shared_cluster_azure_attributes.first_on_demand
    availability        = each.value.databricks_shared_cluster_azure_attributes.availability
    spot_bid_max_price  = each.value.databricks_shared_cluster_azure_attributes.spot_bid_max_price
  }
}
