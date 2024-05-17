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