variable "az_subscription_id" {
  description = "Azure subscription ID to use"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Name of the databricks workspace"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "metastore_id" {
  description = "ID of the metastore to use"
  type        = string
}

variable "catalog_name" {
  type        = string
  description = "Name of the catalog to create"
}

variable "catalog_owner" {
  type        = string
  description = "Owner of the catalog to create"
}

variable "catalog_comment" {
  type        = string
  description = "Comment of the catalog to create"
}

variable "catalog_purpose" {
  type        = string
  description = "Purpose of the catalog to create"
}

variable "catalog_storage_root" {
  type        = string
  description = "Storage root of the catalog to create"
}

variable "catalog_grants" {
  type = map(list(string))
  description = "Grants for the catalog"
}

variable "schemas" {
  type = map(object({
    name         = string
    owner        = string
    comment      = string
    storage_root = string
    grants       = optional(map(list(string)), {})
    properties   = map(string)
  }))
  description = "Schemas to be created"
}

variable "volumes" {
  description = "Volumes to be created"
  type = map(object({
    schema            = string
    volume_type       = string
    name              = string
    owner             = string
    comment           = string
    storage_location  = string
    grants            = map(list(string))
  }))
}