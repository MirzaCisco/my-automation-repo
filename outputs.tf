output "server_ips" {
  description = "The public IPv4 addresses of the created servers"
  value       = [for server in hcloud_server.vpn_servers: server.ipv4_address]
}
