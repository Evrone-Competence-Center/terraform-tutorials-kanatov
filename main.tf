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


resource "yandex_compute_disk" "boot-disk" {
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
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "<зона_доступности>"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}