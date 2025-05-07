output "databricks_storage_credential_id" {
  value = databricks_storage_credential.external_mi.id
}

output "databricks_storage_credential_name" {
  value = databricks_storage_credential.external_mi.name
}

output "databricks_external_locations" {
  value = {
    for el in databricks_external_location.location : el.name => el.id
  }
}