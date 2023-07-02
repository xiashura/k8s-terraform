terraform {
  required_providers {
    kind = {
      source  = "justenwalker/kind"
      version = "0.17.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
  }
}
