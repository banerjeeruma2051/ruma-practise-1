resource "azurerm_virtual_machine" "main" {
    for_each = {
      for k, v in var.vm : k => v if v.os_type == "Linux"
    }
  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  network_interface_ids = each.value.network_interface_ids
  vm_size               = each.value.vm_size
  
  tags = merge({
    Service     = "Core"
    Environment = "Dev"
  }, try(each.value.tags, {}))
  
 

  

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${each.value.computer_name}"
    admin_username = each.value.admin_username
    admin_password = each.value.admin_password # gitleaks:allow
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
resource "azurerm_windows_virtual_machine" "winvm" {
  for_each = {
    for k, v in var.vm : k => v if v.os_type == "Windows"
  }
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password # gitleaks:allow
  network_interface_ids = each.value.network_interface_ids

  tags = merge({
    Service     = "Core"
    Environment = "Dev"
  }, try(each.value.tags, {}))
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}