resource "azapi_resource" "deny_public_ip" {
  type      = "Microsoft.Authorization/policyAssignments@2020-09-01"
  name      = "deny-public-ip"
  parent_id = "/subscriptions/${var.subscription_id}"

  body = jsonencode({
    properties = {
      displayName        = "Deny Public IPs on Network Interfaces"
      policyDefinitionId = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
      notScopes = [
        "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Network/publicIPAddresses/${azurerm_public_ip.bastion_ip.name}"
      ]
    }
  })
}

resource "azapi_resource" "enforce_tags" {
  type      = "Microsoft.Authorization/policyAssignments@2020-09-01"
  name      = "enforce-tags"
  parent_id = "/subscriptions/${var.subscription_id}"

  body = jsonencode({
    properties = {
      displayName        = "Require a tag and its value on resources"
      policyDefinitionId = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"
      parameters = {
        tagName = {
          value = "environment"
        }
        tagValue = {
          value = "production"
        }
      }
      notScopes = [
        # Ignore ALL VM extensions in the resource group
        "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.Compute/virtualMachines/ecotrack-vm/extensions"
      ]
    }
  })
}

resource "azapi_resource" "allowed_locations" {
  type      = "Microsoft.Authorization/policyAssignments@2020-09-01"
  name      = "allowed-locations"
  parent_id = "/subscriptions/${var.subscription_id}"

  body = jsonencode({
    properties = {
      displayName        = "Allowed locations"
      policyDefinitionId = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
      parameters = {
        listOfAllowedLocations = {
          value = ["westeurope"]
        }
      }
    }
  })
}