output "vm_public_ip" {
  description = "The public IP address of the VM."
  value = data.azurerm_public_ip.tabby.ip_address
}
