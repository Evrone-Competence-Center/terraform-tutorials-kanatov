// Create SA
resource "yandex_iam_service_account" "sa-2" {
  folder_id = var.folder_id
  name      = "tf-test-sa-2"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-2.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-2-static-key" {
  service_account_id = yandex_iam_service_account.sa-2.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "s3bucket-1" {
  access_key = yandex_iam_service_account_static_access_key.sa-2-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-2-static-key.secret_key
  bucket     = "tf-s3bucket-2"
}


resource "yandex_compute_disk" "boot_disk" {
  name     = "main-disk"
  type     = "network-ssd"
  zone     = "ru-central1-a"
  size     = "30"
  image_id = "fd8ejsdle3sqfpsgmqeh"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "test"
  platform_id = var.vms_platform_id
  zone        = "ru-central1-a"

  resources {
    cores  = var.vms_cores
    memory = var.vms_mem
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/DiV+iEpistN9+bF+2nXq7RWf0b4PyzaBwhmAJC7IW8TzwQiC5YWT/UG60S6mDLdsV3wcXFq+BaeJeO9TCST4WNsT2l8un0Gs1Cm2p7e9kRxk9XFDpoathV89ecfHUIQvDDpz3OSAWhWmnItQ7tu98E2YBZn6agZPMva55j8x8GPUyjzT874JhpwgKcCFetqoycNJyc85m/Yk0MzCtoOK7igvrnLXQWuz01p7nQ3IZnDttDM0yNpoI7HVCnLWF3iJB2OnUc9mZur5wpagTDrdxXAeawMUG5nK6krzoM0MkqRBE6xFsAOyrQESlQxPnNHisi7dV7bRlblGQn2Ir5kddLSfKBTtSD7efWVkuqV2hKX1/LsSunDoTw+7bcnxNliRvKZO++Dw9n4wAFusiC+7QlTFl2WddPemW8T9GflNYoIzgP8a351PHbjjt0A+5DYpV4tcaC6e5id3SiXKmBc6LTp99x4rbBz/puDh0BZdHjcv6Gr3khvGESPIUFn/t1s= vlad@Mac-mini-Admin.local"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "<зона_доступности>"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = yandex_vpc_network.network-1.id
}