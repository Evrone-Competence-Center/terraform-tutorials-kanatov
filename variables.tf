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

variable "node_mem" {
  type    = number
  default = 4
}

variable "vms_image_id" {
  type    = string
  default = "fd8ejsdle3sqfpsgmqeh"
}

variable "k8s_subnet_id" {
  type    = string
  default = "e9bmbem7id9rfbvqddrs"
}

variable "k8s_network_id" {
  type    = string
  default = "enp67snt19k19j1971ls"
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "git_private_key" {
  type = string
}