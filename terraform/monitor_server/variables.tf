# Network
variable "network_vnet_name" {
  type        = string
  description = "vent that monitor server to install"
}
variable "network_subnet_name" {
  type        = string
  description = "subnet that monitor server to install"
}
variable "network_resource_group_name" {
  type        = string
  description = "network's resource gorup"
}

# Monitor Server 정보
variable "source_image_id" {
  type        = string
  description = "Image Resource ID, Image made by packer"
}
variable "monitor_resource_group_name" {
  type        = string
  description = "resource group that monitor server to install"
  default     = "tig-mgmt-rg"
}
variable "monitor_resource_group_location" {
  type        = string
  description = "location"
  default     = "koreacentral"
}

# 서버 접속 계정
variable "admin_username" {
  type        = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "Password"
}