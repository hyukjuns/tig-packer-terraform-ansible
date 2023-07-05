# Monitor Server
variable "resource_group_name" {
  type        = string
  description = "resource group that monitor server to install"
  default     = "rg-tig-monitoring"
}
variable "location" {
  type        = string
  description = "location"
  default     = "koreacentral"
}
variable "monitor_server_name" {
  type        = string
  description = "monitor server name"
}
variable "source_image_id" {
  type        = string
  description = "Image Resource ID, Image made by packer"
  sensitive   = true
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