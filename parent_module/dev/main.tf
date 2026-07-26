

module "resource_group" {
  source = "../../child_module/resource_group"
  for_each = var.rg
  resource_group = {
    (each.key) = {
      name     = each.value.name
      location = each.value.location
    }
  }
  
}

module "storage_account" {
  source = "../../child_module/storage_account"
  depends_on = [module.resource_group]
  for_each = var.storage_account
  storage_account = {
    (each.key) = {
      name                     = each.value.name
      resource_group_name      = each.value.resource_group_name
      location                 = each.value.location
      account_tier             = each.value.account_tier
      account_replication_type = each.value.account_replication_type
    }
  }
}

module "virtual_network" {
  source = "../../child_module/virtual_network"
  depends_on = [module.resource_group]
  for_each = var.vnet
  virtual_network = {
    (each.key) = {
      name                = each.value.name
      resource_group_name = each.value.resource_group_name
      location            = each.value.location
      address_space       = each.value.address_space
    }
  }
}

module "subnet" {
  source = "../../child_module/subnet"
  depends_on = [module.virtual_network]
  for_each = var.subnet
  subnet = {
    (each.key) = {
      name                 = each.value.name
      resource_group_name  = each.value.resource_group_name
      virtual_network_name = each.value.virtual_network_name
      address_prefixes     = each.value.address_prefixes
    }
  }
}
     
module "nic" {
  source = "../../child_module/nic"
  depends_on = [module.subnet]
  for_each = var.nic
  nic = {
    (each.key) = {
      name                = each.value.name
      location            = each.value.location
      resource_group_name = each.value.resource_group_name
      subnet = {
        (each.key) = {
          id = module.subnet[each.value.subnet_name].subnet[each.value.subnet_name].id
        }
      }
    }
  }
}

module "virtual_machine" {
  depends_on = [module.nic]
  source = "../../child_module/virtual_machine"
  for_each = var.vm
  vm = {
    (each.key) = {
      name                  = each.value.name
      computer_name         = each.value.computer_name
      location              = each.value.location
      resource_group_name   = each.value.resource_group_name
      network_interface_ids = [module.nic[each.value.nic_name].nic[each.value.nic_name].id]
      admin_username        = each.value.admin_username
      admin_password        = each.value.admin_password
      vm_name              = each.value.name
      vm_size              = each.value.vm_size
      os_type               = each.value.os_type
    }
  }
}
