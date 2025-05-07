This example demonstrates how to use Terraform to deploy:

1. External Locations (and permissions)
2. Catalog and schemas (and permissions)

The Terraform state is stored in a remote backend (e.g., Azure Storage Account):
[Store Terraform state in Azure Storage](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

**Important:** Always migrate any existing state before generating or applying a plan to avoid resource conflicts or unintentional deletions.

## How to deploy an environment

1. Login to your cloud provider.
2. Configure the environment for the backend.
3. Configure Terraform backend.
4. Generate the plan.
5. Apply the plan.

```sh
az login

# Set environment variable for backend access key
export ARM_ACCESS_KEY=<your_account_key>

terraform init -backend-config="<env>/<env>_backend.conf" -reconfigure

terraform plan -var-file="<env>/<env>.tfvars" -out=plan/<env>_plan

terraform apply "plan/<env>_plan"
```