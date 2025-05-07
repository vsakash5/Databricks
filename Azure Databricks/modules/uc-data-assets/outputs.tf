output "databricks_catalog_id" {
  value = databricks_catalog.catalog.id
}

output "databricks_catalog_name" {
  value = databricks_catalog.catalog.name
}

output "databricks_schemas" {
  value = {
    for schema in databricks_schema.schema : schema.name => schema.id
  }
}

output "databricks_volumes" {
  value = {
    for volume in databricks_volume.volume : volume.name => volume.id
  }
}
