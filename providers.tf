provider "kind" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    config_path    = "${path.root}/config.yml"
    config_context = "kind-cluster-workshop"
  }
}
