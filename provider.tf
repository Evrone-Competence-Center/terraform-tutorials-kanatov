terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 1.2"
    }
    github = {
      source  = "integrations/github"
      version = ">= 6.1"
    }
    kind = {
      source  = "tehcyx/kind"
      version = ">= 0.4"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "s3-bucket-1"
    region = "ru-central1"
    key    = "terraform.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}

provider "yandex" {
  zone      = "ru-central1-a"
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  #   service_account_key_file = "authorized_key.json"
  token = var.yc_token

}


provider "flux" {
  kubernetes = {
    config_path            = "~/.kube/config"
    # host                   = module.kube.endpoint
    # client_certificate     = base64decode(module.kube.master.client_certificate)
    # client_key             = base64decode(module.kube.master.client_key)
    # cluster_ca_certificate = base64decode(module.kube.master.cluster_ca_certificate)
  }
  git = {
    url    = "https://github.com/lon8/notickets.git"
    http = {
      username = "lon8" # This can be any string when using a personal access token
      password = var.github_token
    }
  }
}

provider "github" {
  owner = lon8
  token = var.github_token
}

# provider "kind" {}