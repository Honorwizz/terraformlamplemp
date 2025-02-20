variable "folder_id" {
  description = "(Optional) - Yandex Cloud Folder ID where resources will be created."
  type        = string
  default     = "folder_id"
}

variable "zone_a" {
  description = "(Optional) - Yandex Cloud Zone for provisoned resources."
  type        = string
  default     = "ru-central1-a"
}

variable "zone_b" {
  description = "(Optional) - Yandex Cloud Zone for provisoned resources."
  type        = string
  default     = "ru-central1-b"
}

variable "lemp" {
  description = "(Optional) - Boot disk image id. If not provided, it defaults to image id"
  type        = string
  default     = "fd8507ofes4220tl4311"
}

variable "lamp" {
  description = "(Optional) - Boot disk image id. If not provided, it defaults to image id"
  type        = string
  default     = "fd812dlakpifp5dosrvc"
}

variable "yandex_access_key" {
  description = "Access Key для Yandex Object Storage"
  type        = string
}

variable "yandex_secret_key" {
  description = "Secret Key для Yandex Object Storage"
  type        = string
  sensitive   = true
}
