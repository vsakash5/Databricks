az_subscription_id                 = "00000000-0000-0000-0000-000000000000"
resource_group                     = "example-dev-resource-group"
databricks_workspace_name          = "example-dev-databricks-ws"
databricks_workspace_host          = "adb-1111111111111111.1.azuredatabricks.net"
tenant_id                          = "11111111-1111-1111-1111-111111111111"
environment                        = "dev"
databricks_metastore_id            = "1234567890abcdef"
catalog_storage_account_name       = "examplestoragecatalogdev"
bronze_storage_account_name        = "examplestoragebronze"
silver_storage_account_name        = "examplestoragesilver"
gold_storage_account_name          = "examplestoragegold"
landing_1_storage_account_name     = "examplestoragelanding1"
landing_2_storage_account_name     = "examplestoragelanding2"
landing_3_storage_account_name     = "examplestoragelanding3"
cdh_storage_account_name           = "examplestoragecdh"
workspace_storage_account_name     = "examplestoragews"
catalog_owner                      = "example-catalog-owner@databricks.com"
ws_catalog_owner                   = "example-ws-catalog-owner@databricks.com"
schemas = {
  "default" = {
    "owner" = "example-catalog-owner@databricks.com"
  }
}
landing_grants_volumes = {
  "landing1" = {
    "user" = "user1@databricks.com"
    "permission" = "READ"
  }
}
cdh_catalog_grants = {
  "cdh" = {
    "user" = "user2@databricks.com"
    "permission" = "SELECT"
  }
}
ws_catalog_grants = {
  "ws" = {
    "user" = "user3@databricks.com"
    "permission" = "MODIFY"
  }
}
sa_catalog_grants = {
  "sa" = {
    "user" = "user4@databricks.com"
    "permission" = "ALL"
  }
}
ws_schemas = {
  "schema1" = {
    "owner" = "example-ws-catalog-owner@databricks.com"
  }
}
