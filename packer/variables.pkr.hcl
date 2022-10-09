# App info
variable "client_id" {
  type      = string
  sensitive = true
}
variable "client_secret" {
  type      = string
  sensitive = true
}
variable "subscription_id" {
  type      = string
  sensitive = true
}
variable "tenant_id" {
  type      = string
  sensitive = true
}

# 이미지가 생성될 리소스그룹(기 존재), 생성될 이미지 이름, 이미지 버전(Azure tags)
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

# InfluxDB
variable "influxdb_db_name" {
  type    = string
  default = "telegraf"
}
variable "influxdb_user_name" {
  type      = string
  sensitive = true
}
variable "influxdb_user_password" {
  type      = string
  sensitive = true
}

# Base Image
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