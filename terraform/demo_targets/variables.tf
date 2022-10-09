variable "resource_group_name" {
  type        = string
  description = "demo targets resource group name"
  default     = "tig-demo-targets-rg"
}
variable "location" {
  type        = string
  description = "location"
  default     = "koreacentral"
}
variable "admin_username" {
  type        = string
  description = "User name"
}
variable "admin_password" {
  type        = string
  description = "Password"
}
