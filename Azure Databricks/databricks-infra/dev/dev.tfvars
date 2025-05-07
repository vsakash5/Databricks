az_subscription_id                 = "00000000-0000-0000-0000-000000000000"
resource_group                     = "example-resource-group"
databricks_workspace_name          = "example-databricks-ws"
databricks_workspace_host          = "adb-1234567890123456.7.azuredatabricks.net"
tenant_id                          = "11111111-1111-1111-1111-111111111111"
environment                        = "dev"
instance_pools = {
  "examplepoolname" = {
    "min_idle_instances" = 0
    "max_capacity"       = 10
    "node_type_id"       = "Standard_DS3_v2"
  }
}
key_vault_name = "example-keyvault"
scope_name = "example-scope"
key_vault_resource_group = "example-keyvault-rg"
databricks_shared_clusters = {
  "shared-cluster-1" = {
    "cluster_name" = "shared-cluster-1"
    "node_type_id" = "Standard_DS3_v2"
    "num_workers"  = 2
  }
}