// Create SA
resource "yandex_iam_service_account" "sa-terraform" {
    name      = "sa-terraform"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "terraform-editor" {
    folder_id = var.yandex_folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa-terraform.id}"
    depends_on = [yandex_iam_service_account.sa-terraform]
}

// Create Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-terraform.id
    description        = "access key"
}

// Keys to create bucket
resource "yandex_storage_bucket" "ntlg-bucket" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "trfrm-tf-bucket"
    acl    = "private"
    force_destroy = true
}

// Create "local_file" for "backend_cfg"
resource "local_file" "backend_cfg" {
  content  = <<EOT
endpoint = "storage.yandexcloud.net"
bucket = "${yandex_storage_bucket.ntlg-bucket.bucket}"
region = "ru-central1"
key = "terraform/terraform.tfstate"
access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
skip_region_validation = true
skip_credentials_validation = true
EOT
  filename = "../../.trfrm/backend.key"
}

// Add "backend_cfg" to bucket
resource "yandex_storage_object" "tfstate" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.ntlg-bucket.bucket
    key = "terraform.tfstate"
    source = "../terraform.tfstate"
    acl    = "private"
    depends_on = [yandex_storage_bucket.ntlg-bucket]
}

