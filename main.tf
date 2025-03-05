terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.35.0"
    }
  }
}

provider "hcloud" {
  # This references a variable for the token.
  # Make sure the actual token is not hard-coded or exposed in any committed files.
  token = var.hcloud_token
}

# Data source to select the most recent Ubuntu 24.04 image.
data "hcloud_image" "ubuntu" {
  name        = "ubuntu-24.04"
  most_recent = true
}

resource "hcloud_ssh_key" "deploy_key" {
  name       = "deploy-key"
  # Redacted the public key and email address.
  public_key = "ssh-rsa [REDACTED_PUBLIC_KEY] [REDACTED_EMAIL]"
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
