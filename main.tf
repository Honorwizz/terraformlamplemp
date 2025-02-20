locals {
  bucket_name = "honorwizz-storage-bucket"
}

# Network Load Balancer
resource "yandex_lb_target_group" "nlb_target_group" {
  name = "my-target-group"

  target {
    subnet_id  = yandex_vpc_subnet.subnet_lemp1.id
    address    = module.ya_instance_1.internal_ip
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet_lemp2.id
    address    = module.ya_instance_2.internal_ip
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  name = "my-load-balancer"

  listener {
    name        = "http"
    port        = 80
    target_port = 80
    protocol    = "tcp"
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.nlb_target_group.id

    healthcheck {
      name = "http-check"
      interval = 2  # Интервал проверки в секундах
      timeout  = 1  # Таймаут ожидания ответа
      unhealthy_threshold = 3  # Сколько раз подряд должен провалиться хелсчек, чтобы инстанс считался недоступным
      healthy_threshold   = 2  # Сколько раз подряд должен пройти хелсчек, чтобы инстанс считался доступным

      http_options {
        port = 80
        path = "/"  # Запрос на этот путь будет проверять работоспособность инстанса
      }
    }
  }
}


# Создание VPC и подсети
resource "yandex_vpc_network" "this" {
  name = "private"
}

resource "yandex_vpc_subnet" "subnet_lemp1" {
  name           = "lemp-subnet1"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_subnet" "subnet_lemp2" {
  name           = "lemp-subnet2"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["192.168.21.0/24"]
}

# Создание диска и виртуальной машины
resource "yandex_compute_disk" "boot_disk" {
  name     = "boot-disk"
  zone     = "ru-central1-a"
  image_id = "fd8507ofes4220tl4311"
  size     = 15
}

module "ya_instance_1" {
  source        = "./modules/"
  instance_name = "lemp"
  zone          = var.zone_a
  cpu           = 2
  memory        = 2
  disk_size     = 20
  image_id      = var.lemp
  subnet_id     = yandex_vpc_subnet.subnet_lemp1.id
  enable_nat    = true
}

module "ya_instance_2" {
  source        = "./modules/"
  instance_name = "lamp"
  zone          = var.zone_b
  cpu           = 2
  memory        = 2
  disk_size     = 20
  image_id      = var.lamp
  subnet_id     = yandex_vpc_subnet.subnet_lemp2.id
  enable_nat    = true
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
}
/*
resource "yandex_storage_object" "file" {
  bucket = local.bucket_name
  key    = "test/terraform.tfstate"
  source = "terraform.tfstate"

  depends_on = [yandex_storage_bucket.test]

}
*/
