
# 🧰 KVM Setup Guide

## 🔐 SSH Access

Ensure your SSH key is available:

```bash
mkdir -p .ssh
ssh-keygen -t ed25519 -b 4096 -f .ssh/id_ed25519
ssh -i .ssh/id_ed25519 <USER>@<IP_ADDRESS>
```

## 📥 Download desired Cloud Image

Navigate to the `assets` directory and download the latest Ubuntu 24.04 LTS (Noble Numbat) cloud image:

```bash
cd assets
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

This `.img` file is a QCOW2 UEFI/GPT bootable disk image suitable for `KVM`, `Proxmox`, and similar environments .

## 📦 Resize the Image (Optional)

(This is not needed, the OpenTofu does it automaticaly)     
If additional disk space is needed, resize the image:

```bash
qemu-img resize noble-server-cloudimg-amd64.img +10G
```

## 🚀 Run the Executor Script

Execute the `executor.py` script:

```bash
# On Linux
python3 executor.py

# On Windows
python executor.py
```

## 🧹 Clean Up with `virsh`

If a domain crashes during development, undefine it:

```bash
virsh undefine <DOMAIN_NAME>
```

To remove associated storage volumes:

```bash
virsh undefine <DOMAIN_NAME> --remove-all-storage
```

*Note: Ensure the domain is shut off before undefining .*

## 🖼️ Visualize with Graphviz

Install Graphviz:

```bash
sudo apt install graphviz
```

Generate a visual representation of your infrastructure:

```bash
tofu graph | dot -Tsvg > graph.svg
```

*This command generates a Graphviz graph of the steps in an operation .*

## 💣 Destroy All Resources

To destroy all managed infrastructure:

```bash
sudo tofu destroy -auto-approve
```
