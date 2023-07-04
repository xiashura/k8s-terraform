provider "kind" {
  kubeconfig = "${path.root}/config.yml"
}


provider "helm" {
  kubernetes {
    config_path    = "${path.root}/config.yml"
    config_context = "kind-cluster-workshop"
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
