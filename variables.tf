variable "cilium" {
  type = object({
    name = optional(string, "asd")
  })
  default = {
    name = "cilium"
  }
  description = "(optional) describe your variable"
}

variable "kind-network-subnet" {
  type    = string
  default = "172.40.0.0/16"
}
