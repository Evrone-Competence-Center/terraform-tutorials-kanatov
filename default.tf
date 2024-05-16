terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

# locals {
#   cloud_id = "b1g1f73gcm5vet9spf42"
#   folder_id = "b1gds5v86pf14bpd23vd"
# }

provider "yandex" {
  zone      = "ru-central1-a"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  #   service_account_key_file = "authorized_key.json"
  token = var.yc_token
}