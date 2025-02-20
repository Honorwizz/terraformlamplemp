#Выгрузка файла состояния в yandex storage
terraform {
  backend "s3" {
    bucket                      = "honorwizz-storage-bucket"
    key                         = "terraform.tfstate"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    region                      = "ru-central1"
    access_key                  = var.yandex_access_key
    secret_key                  = var.yandex_secret_key
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true # Отключаем проверку через AWS API
    skip_requesting_account_id  = true # Отключаем запросы к AWS STS и IAM
  }
}