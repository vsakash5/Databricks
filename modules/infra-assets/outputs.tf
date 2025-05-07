output "databricks_instance_pool_id" {
  value = {
    for instance_pool in databricks_instance_pool.instance_pool : instance_pool.instance_pool_name => instance_pool.id
  }
}

output "databricks_secret_scope_id" {
  value = databricks_secret_scope.kvscope.id
}
