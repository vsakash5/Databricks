data "azurerm_databricks_workspace" "this" {
  name                = var.databricks_workspace_name
  resource_group_name = var.resource_group
}

locals {
  databricks_workspace_host          = data.azurerm_databricks_workspace.this.workspace_url
  databricks_workspace_id            = data.azurerm_databricks_workspace.this.workspace_id
  databricks_workspace_resource_name = "/subscriptions/${var.az_subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Databricks/workspaces/${var.databricks_workspace_name}"
  access_connector_id                = "/subscriptions/${var.az_subscription_id}/resourceGroups/${var.resource_group}/providers/Microsoft.Databricks/accessConnectors/${var.access_connector_name}"
}

// Storage credential creation to be used to create external location
resource "databricks_storage_credential" "external_mi" {
  name = var.access_connector_name
  azure_managed_identity {
    access_connector_id = local.access_connector_id
  }
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
  owner   = var.storage_credential_owner
  comment = var.storage_credential_comment
}

// Give CREATE EXTERNAL LOCATION permission to account_admins group on external_mi storage credential
resource "databricks_grants" "external_creds" {
  storage_credential = databricks_storage_credential.external_mi.id
  dynamic "grant" {
    for_each = var.storage_cred_grants
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}

// Create external location to be used as root storage by dev catalog
resource "databricks_external_location" "location" {
  for_each = var.external_locations
  name     = each.value.name
  url = format("abfss://%s@%s.dfs.core.windows.net/%s",
    each.value.storage_account_container,
  each.value.storage_account_name, each.value.storage_path)
  credential_name = databricks_storage_credential.external_mi.id
  owner           = each.value.owner
  comment         = each.value.comment
  read_only       = each.value.read_only
  skip_validation = each.value.skip_validation
  isolation_mode  = "ISOLATION_MODE_ISOLATED"
  force_update    = true
}

resource "databricks_grants" "location" {
  for_each = var.external_locations

  external_location = databricks_external_location.location[each.key].id
  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}