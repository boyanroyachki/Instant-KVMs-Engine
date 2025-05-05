# Domain name il libvirt, not hostname
variable "hostname" {
  default = "test"
}

# Domain
variable "domain" {
  default = "promcompute.tech"
}

# IP type
variable "ip_type" {
  default = "dhcp"
}

# 40 GB storage
variable "size" {
  default = 40 * 1024 * 1024 * 1024
}

# 2 GB RAM
variable "memoryMB" {
  default = 1024 * 2
}

# 2 vCPUs
variable "cpu" {
  default = 2
}

# Username to be created trough cloudinit
variable "user_name" {
  default = "ubuntu"
}

# Password for cloudinit user
variable "user_password" {
  default = "linux"
}

# Groups for cloudinit user
variable "user_groups" {
  description = "Comma-separated list of groups for the user"
  type        = string
  default     = "users,admin"
}

variable "image_name" {
  default = "noble-server-cloudimg-amd64.img"
}

variable "format" {
  default = "qcow2"
}
