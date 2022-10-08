# Network
variable "network_vnet_name" {
  type = string
  description = "vent that monitor server to install"
}
variable "network_subnet_name" {
  type = string
  description = "subnet that monitor server to install"
}
variable "network_resource_group_name" {
   type = string
  description = "network's resource gorup"
}

# Monitor Server
variable "monitor_resource_group_name" {
  type = string
  description = "resource group that monitor server to install"
  default = "tig-mgmt-rg"
}

variable "monitor_resource_group_location" {
  type = string
  description = "location"
  default = "koreacentral"
}

variable "admin_username" {
  type        = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "Password"
}
variable "influxdb_db_name" {
  type = string
  description = "influxdb database name"
}
variable "db_admin_username" {
  type = string
  description = "db admin username"
}
variable "db_admin_password" {
  type = string
  description = "db admin password"
}
