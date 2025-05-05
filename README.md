### Commands:

SSH via key
```shell
    mkdir .ssh
    ssh -i .ssh/id_ed25519 <USER>@<IP_ADDRESS>
```

Undefine domain virsh
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
    sudo terraform destroy -auto-approve
```

