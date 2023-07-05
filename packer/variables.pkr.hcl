# === Required ===
# App info
variable "client_id" {
  type      = string
  description = "Applicaion ID"
  sensitive = true
}
variable "client_secret" {
  type      = string
  description = "Applicaion Secret"
  sensitive = true
}
variable "subscription_id" {
  type      = string
  description = "Subscription ID"
  sensitive = true
}
variable "tenant_id" {
  type      = string
  description = "Directory ID"
  sensitive = true
}

# === Required ===
# Managed Image info
variable "managed_image_resource_group_name" {
  type        = string
  description = "Resource Group Name, be configured before image creation"
}
variable "managed_image_name" {
  type        = string
  description = "Image Name"
}

# === Required ===
# Influxdb info
variable "influxdb_name" {
  type = string
  description = "Influxdb Database name"
}
variable "influxdb_username" {
  type = string
  description = "Influxdb Database Username"
}
variable "influxdb_password" {
  type = string
  description = "Influxdb Database Password"
}

# === Optional === 
# Base Image info
variable "location" {
  type    = string
  default = "koreacentral"
}
variable "offer" {
  type    = string
  default = "0001-com-ubuntu-server-focal"
}
variable "publisher" {
  type    = string
  default = "Canonical"
}
variable "sku" {
  type    = string
  default = "20_04-lts-gen2"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "size" {
  type    = string
  default = "Standard_DS2_v2"
}
variable "ssh_username" {
  type = string
  default = "azureuser"
}