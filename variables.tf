variable "cilium" {
  type = object({
    name = optional(string, "asd")
  })
  default = {
    name = "cilium"
  }
  description = "(optional) describe your variable"
}
