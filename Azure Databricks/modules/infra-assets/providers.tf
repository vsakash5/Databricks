terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.111.0"
    }

    databricks = {
      source  = "databricks/databricks"
      version = ">=1.48.2"
    }
  }
}
