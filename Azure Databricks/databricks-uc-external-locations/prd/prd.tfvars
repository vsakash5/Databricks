az_subscription_id                 = "00000000-0000-0000-0000-000000000000"
resource_group                     = "example-prd-resource-group"
databricks_workspace_name          = "example-prd-databricks-ws"
databricks_access_connector_name   = "example-prd-access-connector"
databricks_workspace_host          = "adb-2222222222222222.2.azuredatabricks.net"
environment                        = "prd"
catalog_storage_account_name       = "examplestoragecatalogprd"
bronze_storage_account_name        = "examplestoragebronzeprd"
silver_storage_account_name        = "examplestoragesilverprd"
gold_storage_account_name          = "examplestoragegoldprd"
checkpoint_storage_account_name    = "examplestoragecheckpointprd"
landing_1_storage_account_name     = "examplestoragelanding1prd"
landing_2_storage_account_name     = "examplestoragelanding2prd"
landing_3_storage_account_name     = "examplestoragelanding3prd"
aggregations_storage_account_name  = "examplestorageaggregationsprd"
cdh_storage_account_name           = "examplestoragecdhprd"
workspace_storage_account_name     = "examplestoragewsprd"
sparkaggregationfiles_storage_account_name = "examplestoragesparkaggprd"
owner                              = "example-owner-prd@databricks.com"

storage_cred_grants = {
  "default" = {
    "user" = "user1-prd@databricks.com"
    "permission" = "READ"
  }
}
catalog_grants = {
  "catalog1" = {
    "user" = "user2-prd@databricks.com"
    "permission" = "ALL"
  }
}
bronze_grants = {}
silver_grants = {}
gold_grants = {}
bronze_checkpoints_grants = {}
silver_checkpoints_grants = {}
gold_checkpoints_grants = {}
landingzone_1_grants = {}
landingzone_2_grants = {}
landingzone_3_grants = {}
aggregations_grants = {}
workspace_grants = {}
cdh_catalog_grants = {}
cdh_data_grants = {}
sparkaggregationfiles_grants = {}