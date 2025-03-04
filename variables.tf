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
  default     = ["10.0.0.1", "10.0.0.2", "10.0.0.3", "10.0.0.4", "10.0.0.4"]
}
