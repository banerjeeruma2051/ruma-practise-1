resource "azurerm_storage_account" "stg" {
  for_each                      = var.storage_account
  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  public_network_access_enabled = false

  blob_properties {
    last_access_time_enabled = true
  }

  tags = merge({
    Service     = "Core"
    Environment = "Dev"
  }, try(each.value.tags, {}))
}

resource "azurerm_storage_management_policy" "example" {
  for_each           = var.storage_account
  storage_account_id = azurerm_storage_account.stg[each.key].id

  rule {
    name    = "lifecycle"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than = 30
        delete_after_days_since_modification_greater_than       = 365
      }
    }
  }
}