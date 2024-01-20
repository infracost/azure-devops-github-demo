provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "basic_a2"
  resource_group_name = "fake_resource_group"
  location            = "eastus"

  size                = "Basic_A4" # <<<<< Try changing this to Basic_A4 to compare the costs

  tags = {
    Environment = "production"
    Service = "web-app"
  }

  network_interface_ids = [
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/testrg/providers/Microsoft.Network/networkInterfaces/fakenic",
  ]
  admin_username = "fakeuser"
  admin_password = "fakepass"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_app_service_plan" "my_app" {
  name                = "api-appserviceplan-pro"
  location            = "eastus"
  resource_group_name = "fake_resource_group"
  kind                = "elastic"
  reserved            = false

  sku {
    tier     = "PremiumV2"
    size     = "P1v2"
    capacity = 2
  }

  tags = {
    Environment = "Prod"
    Service = "web-app1"
  }
}

resource "azurerm_function_app" "my_function" {
  name                       = "hello-world"
  location                   = "uksouth" # <<<<< Try changing this to EP3 to compare the costs
  resource_group_name        = "fake_resource_group"
  app_service_plan_id        = azurerm_app_service_plan.elastic.id
  storage_account_name       = "fakestorageaccountname"
  storage_account_access_key = "fake_storage_account_access_key"

  tags = {
    Environment = "Prod"
    Service = "api"
  }
}
