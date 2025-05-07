az_subscription_id             = "00000000-0000-0000-0000-000000000000"
resource_group                 = "example-prd-resource-group"
databricks_workspace_name      = "example-prd-databricks-ws"
databricks_workspace_host      = "adb-2222222222222222.2.azuredatabricks.net"
tenant_id                      = "11111111-1111-1111-1111-111111111111"
environment                    = "prd"
databricks_metastore_id        = "abcdef1234567890"
catalog_storage_account_name   = "examplestoragecatalogprd"
bronze_storage_account_name    = "examplestoragebronzeprd"
silver_storage_account_name    = "examplestoragesilverprd"
gold_storage_account_name      = "examplestoragegoldprd"
landing_1_storage_account_name = "examplestoragelanding1prd"
landing_2_storage_account_name = "examplestoragelanding2prd"
landing_3_storage_account_name = "examplestoragelanding3prd"
cdh_storage_account_name       = "examplestoragecdhprd"
workspace_storage_account_name = "examplestoragewsprd"
catalog_owner                  = "example-catalog-owner-prd@databricks.com"
ws_catalog_owner               = "example-ws-catalog-owner-prd@databricks.com"
schemas = {
  "default" = {
    "owner" = "example-catalog-owner-prd@databricks.com"
  }
}
landing_grants_volumes = {
  "landing1" = {
    "user" = "user1-prd@databricks.com"
    "permission" = "READ"
  }
}
cdh_catalog_grants = {
  "cdh" = {
    "user" = "user2-prd@databricks.com"
    "permission" = "SELECT"
  }
}
ws_catalog_grants = {
  "ws" = {
    "user" = "user3-prd@databricks.com"
    "permission" = "MODIFY"
  }
}
sa_catalog_grants = {
  "sa" = {
    "user" = "user4-prd@databricks.com"
    "permission" = "ALL"
  }
}
ws_schemas = {
  "schema1" = {
    "owner" = "example-ws-catalog-owner-prd@databricks.com"
  }
}
