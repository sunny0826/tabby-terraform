provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_virtual_network" "tabby" {
  name                = "tabby-network"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "tabby" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.tabby.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a network interface
resource "azurerm_network_interface" "tabby" {
  name                = "tabby-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tabby.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tabby.id
  }
}

# Create a public IP address
resource "azurerm_public_ip" "tabby" {
  name                = "tabby-publicip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

# Create a network security group
resource "azurerm_network_security_group" "tabby" {
  name                = "tabby-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH_Access"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "App_Access"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the network security group with the network interface
resource "azurerm_network_interface_security_group_association" "tabby" {
  network_interface_id      = azurerm_network_interface.tabby.id
  network_security_group_id = azurerm_network_security_group.tabby.id
}

# Create a VM with a public IP address and a network interface
resource "azurerm_linux_virtual_machine" "tabby" {
  name                            = "tabby-vm"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.tabby.id]
  size                            = var.vm_size
  admin_username                  = "adminuser"
  admin_password                  = "Password1234!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Azure Cli commands to find the correct image
  # find the the publisher
  # $ az vm image list-publishers --location <your-region> --output table
  # find the offer
  # $ az vm image list-offers --location <your-region> --publisher <publisher-name> --output table
  # find the sku
  # $ az vm image list --location <your-region> --publisher <publisher-name> --offer <offer-name> --sku <sku-name> --all --output table

  # source_image_reference {
  #   publisher = "Canonical"
  #   offer     = "0001-com-ubuntu-server-focal"
  #   sku       = "20_04-lts"
  #   version   = "latest"
  # }
  source_image_id = "/subscriptions/141cceea-a5dc-4813-85df-9bc0d0c29e49/resourceGroups/tabby_group/providers/Microsoft.Compute/images/tabby-server-image"
}

