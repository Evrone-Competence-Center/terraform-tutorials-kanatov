terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
  backend "s3" {
    bucket     = "tf-s3bucket-1"
    key        = "terraform.tfstate"
    region     = "ru-central1-a"
    access_key = var.s3_access_key
    secret_key = var.s3_secret_key
  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  #   service_account_key_file = "authorized_key.json"
  token = var.yc_token

}