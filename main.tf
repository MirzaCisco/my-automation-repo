terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.35.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Data source to select the most recent Ubuntu 24.04 image.
data "hcloud_image" "ubuntu" {
  name        = "ubuntu-24.04"
  most_recent = true
}

resource "hcloud_ssh_key" "deploy_key" {
  name       = "deploy-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDavdPPu1NThRQeh54pCwqrtd9K5BzBPRShlFfvNtqMnADb9SDsr6MffdqNKwk0U+z0ttHTw0ysjVOT+NeQG6C4wS/lHsHemzk0NHM+TNtZoQHAYtCT19XUzOgTfRCA6UWD0o9sjEhRHSMmf5mq5c4zpZhUdRXr5EUI3IDXzuNHiAHBbq7tLsss9msVX7ewfNc6wTMjtV+8SR0Ebv18H9kCahnX+iAEdjmMOe+Jobl+O1WVjo5eyIHVV+/uGdKf8KkYkyEtCvUT/I8zF5UxEj94CbMJ5ASc7GVds2YVrhnaOO3sl9ueGhODIG6aXEvCRYgtinbeLueqDINgGro2LxVa4N/sX88FkEqtRA7Te47nwaoWkrBIW9d1PlLAj8tTKlLItagOw0p9I1LoH76EMBF8k0Udf3qaqdGYDDw1hgRGZ/nNrsFsxNd6RRo+ABfWkTwSi1d1J8SMeAZQOZzBTlW2sxuZAFpPxrzve/Of59BaKUA4OBiBUC2ByeYrNHT4kytfmj6b3FynjA4hk/VQQYbAzc9lv+7vMTeFoALTlC/zrTG19tR0WOAa6CIPoBefC/mvHE9L/fRF3nnqIaGFZTdUyEsqMOv6RCeUq7FsTyCC6QHp1X9RzGztgIAb9eZtKrsqGA9Xw5WQnJD5jBdC7SjT0kOK7A/2MHTPhaLb+84D/w== mirza.cerim@outlook.com"
}

resource "hcloud_server" "vpn_servers" {
  count       = length(var.server_names)
  name        = var.server_names[count.index]
  image       = data.hcloud_image.ubuntu.id
  server_type = "cpx21"  # Use a supported server type
  ssh_keys    = [hcloud_ssh_key.deploy_key.id]

  user_data = <<EOF
#!/bin/bash
cat <<EOT > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth1:
      addresses: [${var.internal_ips[count.index]}/24]
      dhcp4: no
EOT
netplan apply
EOF
}
