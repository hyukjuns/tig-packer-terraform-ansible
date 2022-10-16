# App info - Required
variable "client_id" {
  type      = string
  description = "app id"
  sensitive = true
}
variable "client_secret" {
  type      = string
  description = "app pw"
  sensitive = true
}
variable "subscription_id" {
  type      = string
  description = "subscription id"
  sensitive = true
}
variable "tenant_id" {
  type      = string
  description = "directory id"
  sensitive = true
}

# 이미지가 생성될 리소스그룹(기 존재), 생성될 이미지 이름, 이미지 버전(Azure tags) - Required
variable "managed_image_resource_group_name" {
  type        = string
  description = "Resource Group Name, be configured before image creation"
}
variable "managed_image_name" {
  type        = string
  description = "Image Name"
}
variable "image_version" {
  type        = string
  description = "Metadata, Image Version by azure tags"
}

# InfluxDB - Required
variable "influxdb_db_name" {
  type    = string
  description = "InfluxDB Name"
  sensitive = true
}
variable "influxdb_user_name" {
  type      = string
  description = "InfluxDB admin"
  sensitive = true
}
variable "influxdb_user_password" {
  type      = string
  description = "InfluxDB admin password"
  sensitive = true
}

# Base Image - Optional
variable "location" {
  type    = string
  default = "koreacentral"
}
variable "offer" {
  type    = string
  default = "UbuntuServer"
}
variable "publisher" {
  type    = string
  default = "Canonical"
}
variable "sku" {
  type    = string
  default = "18.04-LTS"
}
variable "os_type" {
  type    = string
  default = "Linux"
}
variable "size" {
  type    = string
  default = "Standard_DS2_v2"
}