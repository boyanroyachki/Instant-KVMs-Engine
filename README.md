### Commands:

SSH via key
```shell
    mkdir .ssh
    ssh -i .ssh/id_ed25519 <USER>@<IP_ADDRESS>
```

Get the desired image.
This `.img` file is a `QCOW2 UEFI/GPT` bootable disk image suitable for KVM, Proxmox, and similar environments.
```shell
    cd assets
    wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```
After downloading, you can resize the image if needed:
```shell
    qemu-img resize noble-server-cloudimg-amd64.img +10G
```

Run `executor.py`
```shell
    # if on linux
    python3 executor.py
    # or if you are on windows
    python executor.py
```


If something crashes durring dev, `undefine domain` virsh
```shell
    virsh undefine <DOMAIN_NAME>
```

Visulize using `graphviz`: 
```shell
    sudo apt install graphviz
    tofu graph | dot -Tsvg > graph.svg
```

Destroy all:
```shell
    sudo tofu destroy -auto-approve
```

