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

// Create the catalog
resource "databricks_catalog" "catalog" {
  metastore_id = var.metastore_id
  name         = var.catalog_name
  comment      = var.catalog_comment
  owner        = var.catalog_owner
  storage_root = var.catalog_storage_root
  properties = {
    purpose = var.catalog_purpose
  }
}

resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.catalog.name

  dynamic "grant" {
    for_each = var.catalog_grants
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

// Create schemas
resource "databricks_schema" "schema" {
  for_each     = var.schemas
  catalog_name = databricks_catalog.catalog.id
  name         = each.value.name
  owner        = each.value.owner
  comment      = each.value.comment
  storage_root = each.value.storage_root
  properties = each.value.properties
}

// Grants on schemas
resource "databricks_grants" "schemas" {
  for_each = var.schemas

  schema = databricks_schema.schema[each.key].id

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

// Create volumes
resource "databricks_volume" "volume" {
  for_each         = var.volumes
  catalog_name     = databricks_catalog.catalog.id
  // the schema name is extracted from the id which is in the form of <catalog_name>.<schema_name>
  schema_name      = split(".", databricks_schema.schema[each.value.schema].id)[1]
  volume_type      = each.value.volume_type
  name             = each.value.name
  owner            = each.value.owner
  comment          = each.value.comment
  storage_location = each.value.storage_location
}

// Grants on volumes
resource "databricks_grants" "volumes" {
  for_each = var.volumes

  volume = databricks_volume.volume[each.key].id

  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

