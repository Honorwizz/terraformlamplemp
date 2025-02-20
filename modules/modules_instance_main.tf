terraform {
  required_version = ">= 1.3.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.138.0"
    }
  }
}

resource "yandex_compute_instance" "vm" {
  name        = var.instance_name
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores         = var.cpu
    memory        = var.memory
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = var.enable_nat
  }
}
