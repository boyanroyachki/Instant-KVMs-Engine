
#--- GET ISO IMAGE

# Base image volume
resource "libvirt_volume" "os_image_base" {
  name   = "${var.hostname}-os_image_base"
  pool   = "default"
  source = "${var.image_name}"
  format = var.format
}

# Resized OS volume (40 GB)
resource "libvirt_volume" "os_image" {
  name           = "${var.hostname}-os_image"
  pool           = "default"
  base_volume_id = libvirt_volume.os_image_base.id
  size           = var.size
  format         = var.format
}

#--- CUSTOMIZE ISO IMAGE

# 1a. Retrieve our local cloud_init.cfg and update its content (= add ssh-key) using variables
data "template_file" "user_data" {
  template = file("${path.module}/assets/cloud_init.cfg")
  vars = {
    hostname      = var.hostname
    user_name     = var.user_name
    user_password = var.user_password
    user_groups   = var.user_groups
    fqdn          = "${var.hostname}.${var.domain}"
    # public_key    = file("${path.module}/.ssh/id_ed25519.pub")
  }
}

# 1b. Save the result as init.cfg
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user_data.rendered
  }
}

# 2. Retrieve our network_config
data "template_file" "network_config" {
  template = file("${path.module}/assets/network_config_${var.ip_type}.cfg")
}

# 3. Add ssh-key and network config to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.hostname}-commoninit.iso"
  pool           = "default"
  user_data      = data.template_cloudinit_config.config.rendered
  network_config = data.template_file.network_config.rendered
}

#--- CREATE VM

resource "libvirt_domain" "domain-ubuntu" {
  name   = var.hostname
  memory = var.memoryMB
  vcpu   = var.cpu

  #  cpu {
  #    quota = 50000  # Microseconds of CPU time per period
  #    period = 100000  # Microseconds; default is 100000
  #  }

  disk {
    volume_id = libvirt_volume.os_image.id
  }
  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}
