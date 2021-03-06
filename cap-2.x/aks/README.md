## Directory structure

* `aks/cluster` contains the AKS cluster setup related terraform templates.

* `common` (linked to the `../common` directory), contains three sub-directories: `helper-charts` containing templates for various helper helm charts (`external-dns` and `cert-manager`), `kubecf-charts` for `KubeCF`, and `stratos-charts` for `Stratos` and `Metrics` charts.

## Prerequisites

* Create an Azure Service Principal
  ```
  az ad sp create-for-rbac
  ```
  Note the SP must have sufficient privileges, the created account must have at least Contributor and DNS Zone Contributor roles. The data provided as output from this function will be required in the terraform variables.

* Create a Resource Group
  ```
  az group create --name $(az_resource_group) --location $(location)
  ```
  This resource group will contain all resources of, and in support of your SUSE CAP cluster. Make note of the _name_ and _location_ which must be supplied in terraform variables.

* Create a DNS zone
  ```
  az network dns zone create -g $(az_resource_group) -n $(dns_zone_name)
  ```
  The DNS zone will host the cluster's DNS records in a specific domain name. Make note of the _name_ which must be supplied in terraform variables. See https://docs.microsoft.com/en-us/azure/dns/ for details on setting up a DNS zone.

## Setup

1. Create a `terraform.tfvars` or `terraform.tfvars.json` file with the following information:
    - `instance_count` - The number of worker nodes in your cluster. (Minimum: 3, Maximum 50)
    - `instance_type` - The type of instance used for the provisioned workers.
    - `subscription_id` - Azure subscription ID
    - `resource_group` - An existing Azure Resource Group where resources will be created.
    - `location` - The Azure region where the Resource Group is placed.
    - `client_id` - Azure Service Principal 'appId'
    - `client_secret` - Azure Service Principal 'password'
    - `tenant_id` - "Azure Service Principal 'tenant'"
    - `ssh_username` - SSH username for accessing the cluster.
    - `ssh_public_key` - SSH public key (the content) for access to worker nodes.
    - `admin_password` - Intial password for Cloud Foundry 'admin' user, UAA 'admin' OAuth client, and metrics 'admin' login. We recommend changing this password after deployment. See https://documentation.suse.com/suse-cap/single-html/cap-guides/#cha-cap-manage-passwords
    - `k8s_version` - Kubernetes version to apply to AKS; must be supported in the selected region. (Run `az aks get-versions --location $REGION --output table` for a list of supported options)
    - `disk_size_gb` - The worker node storage capacity. (Minimum:80, Maximum: 4095)
    - `cluster_labels` - Tags to be applied to resources in your cluster. (Optional)
    - `dns_zone_name` - Name of the Azure DNS Zone created for the cluster.
    - `cap_domain` - The FQDN for the CAP deployment.
    - `dns_prefix` - Prefix for node DNS hostnames. (Must be alphanumeric, may include but not end with dashes) (Optional)
    - `email` - Email address to send TLS certificate notifications to.
    - `eirini_enabled` - Deploy with Eirini (default = "true") or Diego ("false") (Optional)
    - `ha_enabled`  - Deploy CAP in high availability mode (default = "false") (Optional)

    **⚠ NOTE:** _This should be in your `.gitignore` or otherwise outside source control as it contains sensitive information._

2. `terraform init`

3. `terraform plan -out <PLAN-path>`

4. `terraform apply <PLAN-path>`

## Results

* All CAP services including Stratos and Metrics would be installed with an Ingress Controller. You can configure the endpoint
settings in the various helm chart configuration values in the cap-charts directory.

* A kubeconfig named `kubeconfig` is generated in the same directory TF is run from. Set your `KUBECONFIG` env var to point to this file.

* The `helm install`s should have been triggered as part of step 4. Check the pods in kubecf, stratos and metrics namespace to make sure they all come up and are ready.
