variable "location" {
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
