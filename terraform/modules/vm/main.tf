resource "azurerm_public_ip" "this" {
  count               = var.public_ip ? 1 : 0
  name                = "${var.prefix}-${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "this" {
  name                = "${var.prefix}-${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip ? azurerm_public_ip.this[0].id : null
  }
}

resource "random_password" "admin" {
  count    = var.admin_password == "" ? 1 : 0
  length   = 16
  special  = true
}

resource "azurerm_windows_virtual_machine" "this" {
  count               = var.os == "windows" ? 1 : 0
  name                = "${var.prefix}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.this.id]
  size                 = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password != "" ? var.admin_password : random_password.admin[0].result

  source_image_reference {
    publisher = var.windows_image.publisher
    offer     = var.windows_image.offer
    sku       = var.windows_image.sku
    version   = var.windows_image.version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  count               = var.os == "linux" ? 1 : 0
  name                = "${var.prefix}-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.this.id]
  size                 = var.vm_size

  admin_username = var.admin_username

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key != "" ? [var.admin_ssh_key] : []
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  disable_password_authentication = var.admin_ssh_key != ""

  admin_password = var.admin_ssh_key == "" ? (var.admin_password != "" ? var.admin_password : random_password.admin[0].result) : null

  source_image_reference {
    publisher = var.linux_image.publisher
    offer     = var.linux_image.offer
    sku       = var.linux_image.sku
    version   = var.linux_image.version
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
