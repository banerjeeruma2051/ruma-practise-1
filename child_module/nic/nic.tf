resource "azurerm_network_interface" "nic" {
  for_each            = var.nic
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tags = merge({
    Service     = "Core"
    Environment = "Dev"
  }, try(each.value.tags, {}))

  ip_configuration {
    name                          = each.value.name
    subnet_id                     = each.value.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}