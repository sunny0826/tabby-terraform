data "azurerm_public_ip" "tabby" {
  name                = azurerm_public_ip.tabby.name
  resource_group_name = azurerm_linux_virtual_machine.tabby.resource_group_name
}