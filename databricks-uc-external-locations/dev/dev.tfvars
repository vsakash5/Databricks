az_subscription_id                 = "00000000-0000-0000-0000-000000000000"
resource_group                     = "example-dev-resource-group"
databricks_workspace_name          = "example-dev-databricks-ws"
databricks_access_connector_name   = "example-dev-access-connector"
databricks_workspace_host          = "adb-1111111111111111.1.azuredatabricks.net"
environment                        = "dev"
catalog_storage_account_name       = "examplestoragecatalogdev"
bronze_storage_account_name        = "examplestoragebronze"
silver_storage_account_name        = "examplestoragesilver"
gold_storage_account_name          = "examplestoragegold"
checkpoint_storage_account_name    = "examplestoragecheckpoint"
landing_1_storage_account_name     = "examplestoragelanding1"
landing_2_storage_account_name     = "examplestoragelanding2"
landing_3_storage_account_name     = "examplestoragelanding3"
aggregations_storage_account_name  = "examplestorageaggregations"
cdh_storage_account_name           = "examplestoragecdh"
workspace_storage_account_name     = "examplestoragews"
owner                              = "example-owner@databricks.com"
sparkaggregationfiles_storage_account_name = "examplestoragesparkagg"

storage_cred_grants = {
  "default" = {
    "user" = "user1@databricks.com"
    "permission" = "READ"
  }
}
catalog_grants = {
  "catalog1" = {
    "user" = "user2@databricks.com"
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