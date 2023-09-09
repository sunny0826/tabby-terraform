# Tabby Terraform

## Azure

This Terraform project provisions a GPU-enabled virtual machine (VM) on Azure, sets up a public IP for it, and runs a [Tabby](https://tabbyml.github.io/tabby/docs/self-hosting/docker) Docker instance.

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed.
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated.
- An active Azure subscription.

### Setup

1. **Azure Authentication**: Ensure you're logged into Azure using the Azure CLI:

    ```bash
    az login
    ```

    Once you have chosen the account subscription ID, set the account with the Azure CLI.

    ```bash
    az account set --subscription "35akss-subscription-id"
    ```

2. Create a Service Principal

    ```bash
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"

    Creating 'Contributor' role assignment under scope '/subscriptions/35akss-subscription-id'
    The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
    {
    "appId": "xxxxxx-xxx-xxxx-xxxx-xxxxxxxxxx",
    "displayName": "azure-cli-2022-xxxx",
    "password": "xxxxxx~xxxxxx~xxxxx",
    "tenant": "xxxxx-xxxx-xxxxx-xxxx-xxxxx"
    }
    ```

3. Set your environment variables

    Set the necessary environment variables for Terraform to authenticate with Azure:

    ```bash
    export ARM_CLIENT_ID="<APPID_VALUE>"
    export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
    export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
    export ARM_TENANT_ID="<TENANT_VALUE>"
    ```

4. **Initialization**: Navigate to the project directory and run:

    ```bash
    cd azure
    terraform init
    ```

5. **plan**: To see what resources will be created, run:

    ```bash
    terraform plan
    ```

6. **Apply Configuration**: To provision the resources on Azure, run:

    ```bash
    terraform apply
    ```

    This command will show a plan and prompt you for confirmation. Type `yes` to proceed.

7. **Destroy Resources**: If you wish to remove all the resources created by this project, run:

    ```bash
    terraform destroy
    ```

    This will show a plan for destroying resources and will prompt for confirmation.

### Outputs

- `vm_public_ip`: The public IP address of the provisioned VM.

### Usage

Access `http://vm_public_ip:8080` to view the Tabby service.

### Notes

- Ensure you have set the correct region in `variables.tf` or provide it during the `terraform apply` command.
- Always review the Terraform plan output before applying any changes.
- Monitor your Azure resources and billing to avoid unexpected charges.
