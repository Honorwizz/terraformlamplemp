# Проект Terraform для Yandex Cloud

## Описание
Этот проект автоматизирует развертывание облачной инфраструктуры в **Yandex Cloud** с использованием **Terraform**. Включает создание виртуальных машин, сетевой инфраструктуры, хранилища состояния, балансировщика нагрузки и валидацию кода с помощью линтеров.

## Выполненные задачи

### **1. Создание виртуального инстанса с LEMP**

✅ Создан инстанс (виртуальная машина) со следующими характеристиками:
- **CPU**: 2 ядра
- **RAM**: 2 ГБ
- **Образ**: LEMP
- **Регион подсети**: `ru-central1-a`
- Выдан **внешний IP**
- Использованы ресурсы:
  - `yandex_compute_instance`
  - `yandex_vpc_network`
  - `yandex_vpc_subnet`
- Образ инстанса получен через **`data "yandex_compute_image"`**.

### **2. Создание хранилища для состояния Terraform**

✅ Реализовано удалённое хранилище для хранения `terraform.tfstate`.

**Шаги:**
1. Создан сервисный аккаунт в **Yandex Cloud** (`yandex_iam_service_account`).
2. Выданы права `storage.editor` для доступа к **Yandex Object Storage**.
3. Созданы ключи доступа (`access_key`, `secret_key`).
4. Развернуто хранилище **Yandex Object Storage** (`yandex_storage_bucket`).
5. Вывод ключей добавлен в `output.tf` для повторного использования.
6. Конфигурация `backend "s3"` добавлена в `terraform {}`.
7. Инициализировано удалённое хранилище (`terraform init -force-copy`).

### **3. Добавление второго инстанса и вынесение кода в модуль**

✅ Развёрнут второй инстанс с **LAMP**:
- **Образ**: LAMP
- **Регион подсети**: `ru-central1-b`
- **Общая VPC-сеть**, но разные подсети

✅ Вынесение повторяющегося кода в **модуль**:
1. Создана локальная директория **`modules/instance`**.
2. Вынесены ресурсы `yandex_compute_instance` в модуль.
3. Переписан основной код для использования модуля.
4. Подключение модуля:
   ```hcl
   module "instance_1" {
     source = "./modules/instance"
     image  = "LEMP"
     zone   = "ru-central1-a"
   }
   
   module "instance_2" {
     source = "./modules/instance"
     image  = "LAMP"
     zone   = "ru-central1-b"
   }
   ```

### **4. Версионирование и настройка pre-commit с Tflint**

✅ Добавлено версионирование:
- Версия Terraform:
  ```hcl
  terraform {
    required_version = ">= 1.3"
    required_providers {
      yandex = {
        source  = "yandex-cloud/yandex"
        version = ">= 0.90.0"
      }
    }
  }
  ```

✅ Настроен **pre-commit Terraform** и **Tflint**:
1. Установлен `pre-commit`.
2. В репозитории добавлен `.pre-commit-config.yaml`.
3. Активированы проверки:
   - `terraform_fmt`
   - `terraform_validate`
   - `terraform_docs`
   - `terraform_tflint`
4. Запуск проверки:
   ```sh
   pre-commit run -a
   ```

### **5. Добавление Network Load Balancer**

✅ Реализован **балансировщик нагрузки** (Network Load Balancer) для инстансов:
1. Создан ресурс `yandex_lb_network_load_balancer`.
2. Инстансы добавлены в пул балансировки.
3. Настроено равномерное распределение трафика между серверами.
4. Проверка доступа возможна:
   - По IP балансировщика.
   - По публичным IP инстансов.

---

## **Запуск проекта**

1. Установите **Terraform**.
2. Настройте **ключи доступа** в `terraform.tfvars`:
   ```hcl
   yandex_access_key = "ВАШ_ACCESS_KEY"
   yandex_secret_key = "ВАШ_SECRET_KEY"
   ```
3. Выполните инициализацию:
   ```sh
   terraform init
   ```
4. Запустите развертывание:
   ```sh
   terraform apply -auto-approve
   ```

---

## **Технологии**
- **Terraform** (управление инфраструктурой)
- **Yandex Cloud** (облачная платформа)
- **Pre-commit, Tflint** (линтеры и валидация кода)
- **Network Load Balancer** (распределение нагрузки)
- **S3 Backend** (удалённое хранилище состояния)

### **Авторы**
Проект разработан и автоматизирован с использованием Terraform и Yandex Cloud.# Проект Terraform для Yandex Cloud

## Описание
Этот проект автоматизирует развертывание облачной инфраструктуры в **Yandex Cloud** с использованием **Terraform**. Включает создание виртуальных машин, сетевой инфраструктуры, хранилища состояния, балансировщика нагрузки и валидацию кода с помощью линтеров.

## Выполненные задачи

### **1. Создание виртуального инстанса с LEMP**

✅ Создан инстанс (виртуальная машина) со следующими характеристиками:
- **CPU**: 2 ядра
- **RAM**: 2 ГБ
- **Образ**: LEMP
- **Регион подсети**: `ru-central1-a`
- Выдан **внешний IP**
- Использованы ресурсы:
  - `yandex_compute_instance`
  - `yandex_vpc_network`
  - `yandex_vpc_subnet`
- Образ инстанса получен через **`data "yandex_compute_image"`**.

### **2. Создание хранилища для состояния Terraform**

✅ Реализовано удалённое хранилище для хранения `terraform.tfstate`.

**Шаги:**
1. Создан сервисный аккаунт в **Yandex Cloud** (`yandex_iam_service_account`).
2. Выданы права `storage.editor` для доступа к **Yandex Object Storage**.
3. Созданы ключи доступа (`access_key`, `secret_key`).
4. Развернуто хранилище **Yandex Object Storage** (`yandex_storage_bucket`).
5. Вывод ключей добавлен в `output.tf` для повторного использования.
6. Конфигурация `backend "s3"` добавлена в `terraform {}`.
7. Инициализировано удалённое хранилище (`terraform init -force-copy`).

### **3. Добавление второго инстанса и вынесение кода в модуль**

✅ Развёрнут второй инстанс с **LAMP**:
- **Образ**: LAMP
- **Регион подсети**: `ru-central1-b`
- **Общая VPC-сеть**, но разные подсети

✅ Вынесение повторяющегося кода в **модуль**:
1. Создана локальная директория **`modules/instance`**.
2. Вынесены ресурсы `yandex_compute_instance` в модуль.
3. Переписан основной код для использования модуля.
4. Подключение модуля:
   ```hcl
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
   ```

### **4. Версионирование и настройка pre-commit с Tflint**

✅ Добавлено версионирование:
- Версия Terraform:
  ```hcl
  terraform {
    required_version = ">= 1.3.0"

    required_providers {
        yandex = {
        source  = "yandex-cloud/yandex"
        version = "=0.138.0"
        }
    }
  }
  ```

✅ Настроен **pre-commit Terraform** и **Tflint**:
1. Установлен `pre-commit`.
2. В репозитории добавлен `.pre-commit-config.yaml`.
3. Активированы проверки:
   - `terraform_fmt`
   - `terraform_validate`
   - `terraform_docs`
   - `terraform_tflint`
4. Запуск проверки:
   ```sh
   pre-commit run -a
   ```

### **5. Добавление Network Load Balancer**

✅ Реализован **балансировщик нагрузки** (Network Load Balancer) для инстансов:
1. Создан ресурс `yandex_lb_network_load_balancer`.
2. Инстансы добавлены в пул балансировки.
3. Настроено равномерное распределение трафика между серверами.
4. Проверка доступа возможна:
   - По IP балансировщика.
   - По публичным IP инстансов.

---

## **Запуск проекта**

1. Установите **Terraform**.
2. Настройте **ключи доступа** в `terraform.tfvars`:
   ```hcl
   yandex_access_key = "ВАШ_ACCESS_KEY"
   yandex_secret_key = "ВАШ_SECRET_KEY"
   ```
3. Выполните инициализацию:
   ```sh
   terraform init
   ```
4. Запустите развертывание:
   ```sh
   terraform apply -auto-approve
   ```

---

## **Технологии**
- **Terraform** (управление инфраструктурой)
- **Yandex Cloud** (облачная платформа)
- **Pre-commit, Tflint** (линтеры и валидация кода)
- **Network Load Balancer** (распределение нагрузки)
- **S3 Backend** (удалённое хранилище состояния)

### **Авторы**
Проект разработан и автоматизирован с использованием Terraform и Yandex Cloud.