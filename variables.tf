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

variable "vms_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "Platform ID for VM in YC"
}

variable "vms_mem" {
  type    = number
  default = 2
}

variable "vms_cores" {
  type    = number
  default = 2
}