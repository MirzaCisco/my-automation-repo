variable "hcloud_token" {
  description = "Hetzner API Token"
  type        = string
}

variable "server_names" {
  description = "List of server names"
  type        = list(string)
  default     = ["server1", "server2", "server3", "server4", "server5"]
}

variable "internal_ips" {
  description = "List of internal IP addresses for each server"
  type        = list(string)
  default     = ["10.x.x.1", "10.x.x.2", "10.x.x.3", "10.x.x.4", "10.x.x.5"]
}
