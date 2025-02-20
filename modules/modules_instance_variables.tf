variable "instance_name" { type = string }
variable "zone" { type = string }
variable "cpu" { type = number }
variable "memory" { type = number }
variable "disk_size" { type = number }
variable "image_id" { type = string }
variable "subnet_id" { type = string }
variable "enable_nat" { type = bool }
