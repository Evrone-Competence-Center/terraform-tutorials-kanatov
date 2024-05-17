// Create SA
resource "yandex_iam_service_account" "sa-2" {
  folder_id = var.folder_id
  name      = "tf-test-sa"
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

resource "yandex_compute_instance" "vm-1" {
  name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = var.vms_cores
    memory = var.vms_mem
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ejsdle3sqfpsgmqeh"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.foo.id
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["10.5.0.0/24"]
}