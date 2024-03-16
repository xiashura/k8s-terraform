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


variable "kind-cluster" {
  description = "you can choose cluster in folder cluster"
  type        = string
  default     = "kind-single-master-node.yml"
}


variable "istio" {
  type    = bool
  default = false
}

variable "argocd" {
	type = bool
	default = true
}

variable "ingress-nginx" {
	type = bool
	default = true
}


variable "vault" {
	type = bool
	default = true
}
