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