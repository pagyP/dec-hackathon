provider "random" {}
provider "local" {}

resource "random_pet" "example" {
  length = var.name_length
}

resource "local_file" "example" {
  content  = "Random name: ${random_pet.example.id}\n"
  filename = "${path.module}/.terraform/${random_pet.example.id}.txt"
}

# Create VMs in spokes
module "ubuntu_vm" {
  source = "./modules/vm"
  prefix = var.prefix
  name = "ubuntu-vm"
  resource_group_name = module.rg.name
  location = var.location
  subnet_id = module.spoke_app_vnet.subnets["app-subnet-1"]
  os = "linux"
  admin_username = "ubuntu"
  admin_password = var.linux_admin_password
  public_ip = false
}

module "windows_vm" {
  source = "./modules/vm"
  prefix = var.prefix
  name = "windows-vm"
  resource_group_name = module.rg.name
  location = var.location
  subnet_id = module.spoke_onprem_vnet.subnets["onprem-subnet-1"]
  os = "windows"
  admin_username = "azureuser"
  admin_password = var.windows_admin_password
  public_ip = false
}
