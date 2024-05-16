variable "yc_token" {
  type        = string
  description = "IAM-token for auth to YC"
}

variable "cloud_id" {
  type        = string
  description = "Cloud ID for YC"
}

variable "folder_id" {
  type        = string
  description = "Folder ID for YC"
}

variable "vms_mem" {
  type    = number
  default = 4
}

variable "vms_cores" {
  type    = number
  default = 2
}

variable "s3_access_key" {
  type        = string
  description = "Access key for Object Storage in YC"
}

variable "s3_secret_key" {
  type        = string
  description = "Secret key for Object Storage in YC"
}