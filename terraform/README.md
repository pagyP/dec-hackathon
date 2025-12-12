# Terraform skeleton

This folder contains a small Terraform example intended to be a safe, minimal starting point.

Getting started

1. Install Terraform (https://www.terraform.io/downloads).
2. Initialize:

```bash
cd terraform
terraform init
```

3. Validate & preview:

```bash
terraform fmt -check
terraform validate
terraform plan
```

4. Apply (this will create a small local file resource):

```bash
terraform apply
```

Notes

- State is stored locally by default. Configure a remote backend for team usage.
- The example creates a `random_pet` and writes a file into `.terraform/`.
## Azure example

This folder now includes an opinionated Azure example that creates:

- A resource group
- A hub virtual network and two spokes (one designated to simulate on-prem)
- VNet peerings (hub <-> each spoke)
- Optional VPN gateway and site-to-site connection to simulate an on-prem peer (disabled by default)
- Hub subnets for Azure Bastion and Azure Private DNS Resolver (the resolver requires two subnets)

Important: deploying VPN gateways, public IPs, Azure Bastion, or Azure Private DNS Resolver can incur real Azure costs. Keep `create_vpn = false` and avoid adding extra services unless you understand and accept those costs.

Note: Azure Bastion requires its subnet to be named `AzureBastionSubnet`. The hub VNet will by default create a subnet with that name unless you override `azure_bastion_subnet`.

The repository can optionally deploy Azure Bastion (controlled via `create_bastion`) and a Private DNS baseline (linking a Private DNS zone to the hub VNet). These are disabled by default in `terraform.tfvars.example`.

VMs in spokes

- The project can create VMs into spoke VNets. The root variables `spoke_app_subnets` and `spoke_onprem_subnets` control the two subnets created in each spoke.
- By default the repo creates one Ubuntu VM in the app spoke and one Windows VM in the on-prem spoke. Configure VM credentials via `linux_admin_password` and `windows_admin_password` (both sensitive) or provide `linux_ssh_public_key` to use SSH key auth for Linux.

Example usage (plan):

```bash
terraform plan -var-file=terraform.tfvars.example
```

To use the Azure example:

```bash
cd terraform
# ensure you are authenticated (e.g. az login)
terraform init
terraform plan -var 'create_vpn=false'
# or to enable VPN simulation
# terraform plan -var 'create_vpn=true' -var 'onprem_gateway_ip=<ip>'
```

Passing custom subnets for a VNet:

Example - create two subnets on the hub VNet (in `terraform/terraform.tfvars` or via CLI):

```hcl
hub_subnets = [
  { name = "app", address_prefix = "10.0.1.0/24" },
  { name = "db",  address_prefix = "10.0.2.0/24" },
]
```

Then reference them when planning/applying, or put them in `terraform.tfvars` (see `terraform.tfvars.example` in this folder for a copyable example):

```bash
terraform plan -var='hub_subnets=[{"name":"app","address_prefix":"10.0.1.0/24"},{"name":"db","address_prefix":"10.0.2.0/24"}]'
```

**Hackathon: DNS Resolver How-To**

- Goal: iterate quickly on Private DNS Resolver behavior by editing `modules/private_dns_resolver`.
- Quick flow:
  1. Edit `modules/private_dns_resolver/main.tf` to add resolver endpoints, forwarding rules, or logging.
  2. From `terraform/`: run `terraform init` (if you changed providers) and `terraform plan` to review changes.
  3. Apply cautiously in a test subscription: `terraform apply -var 'create_bastion=false'` (use `-auto-approve` if desired).
  4. Verify in Azure Portal or with CLI (e.g., inspect the Private DNS zone and resources in the Resource Group).
- Tips: keep resource sizes small to limit cost; add tags for tracking; test in a disposable subscription or resource group.
- If you see PlatformImageNotFound errors (e.g. "Canonical:UbuntuServer:20_04-lts:latest not found"), the requested image SKU may not be available in the region or marketplace. Use the Azure CLI to find valid images for your region:

  ```bash
  az vm image list --publisher Canonical --offer UbuntuServer --all --output table
  az vm image show --urn Canonical:UbuntuServer:18.04-LTS:latest
  ```

  Then override the image in `terraform.tfvars` (see `linux_image` variable) with a SKU available in your region.
- Docs: see Azure Private DNS Resolver docs for APIs and examples (search "Azure Private DNS Resolver" on docs.microsoft.com).
