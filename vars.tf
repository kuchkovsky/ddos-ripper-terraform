variable "targets" {
  type        = string
  default     = "8.8.8.8:443,8.8.4.4:443" # Google DNS website as an example
  description = "Target IP and Ports specified in format IP1:PORT1,IP2:PORT2"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of replicas for each target"
}

variable "turbo" {
  type        = number
  default     = 135
  description = "DDOS intensity. Can be either 135 or 443"
}
