



resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group
  name     = each.value.name
  location = each.value.location

  tags = merge({
    Service     = "Core"
    Environment = "Dev"
  }, try(each.value.tags, {}))
}



