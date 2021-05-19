
variable "rg" {
  type = string
 
}
variable "location" {
  type = string
  
}
variable "vnet" {
  type = string
  
}
variable "vnet_address_space" {
  type = list
 
}

variable "subnet" {
  type = string
  
}
variable "subnet_address_space" {
  type = list
  
}
variable "nic" {
  type = string
  
}
variable "pip" {
  type = string
   
}
variable "nsg" {
  type = string
  
}
variable "vm" {
  type = string
 
}
variable "keyvault" {
  type = string
  
}
variable "keyvaultsecret" {
  type = string
  
}
