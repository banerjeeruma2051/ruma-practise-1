rg = {
  rg1 = {
    name     = "rg1som"
    location = "East Asia"
  },
  
  }


storage_account = {
  sa1 = {
    name                     = "somexamplestgacct1a"
    resource_group_name      = "rg1som"
    location                 = "East Asia"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  },
  
}

vnet = {
  vnet1 = {
    name                = "vnet1"
    resource_group_name = "rg1som"
    location            = "East Asia"
    address_space       = ["10.0.0.0/16"]
  },

}

subnet = {
  subnet1 = {
    name                 = "subnet1"
    resource_group_name  = "rg1som"
    virtual_network_name = "vnet1"
    address_prefixes     = ["10.0.1.0/24"]
  },
  subnet2 = {
    name                 = "subnet2"
    resource_group_name  = "rg1som"
    virtual_network_name = "vnet1"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

nic = {
  nic1 = {
    name                = "somnic1"
    location            = "East Asia"
    resource_group_name = "rg1som"
    subnet_name         = "subnet1"
    network_interface_ids = ""
  },
  nic2 = {
    name                = "somnic2"
    location            = "East Asia"
    resource_group_name = "rg1som"
    subnet_name         = "subnet2"
    network_interface_ids = ""
  }
}

vm = {
  vm1 = {
    name                  = "vm1"
    computer_name         = "vm1-computer"
    location              = "East Asia"
    resource_group_name   = "rg1som"
    nic_name              = "nic1"
    admin_username        = "testadmin"
    admin_password        = "Password1234!"
    vm_size              = "Standard_D2s_v5"
    os_type               = "Linux"
  },
  vm2 = {
    name                  = "vm2"
    computer_name         = "vm2-computer"
    location              = "East Asia"
    resource_group_name   = "rg1som"
    nic_name              = "nic2"
    admin_username        = "testadmin"
    admin_password        = "Password1234!"
    vm_size              = "Standard_D2s_v5"
    os_type               = "Windows"
  }
}
