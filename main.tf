resource "kind_cluster" "workshop" {
  name   = "cluster-workshop"
  config = file("${path.root}/clusters/kind.yml")
}

resource "helm_release" "cni" {
  name             = "cilium"
  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  namespace        = "kube-system"
  values = [
    templatefile("${path.root}/charts/cilium.yml", var.cilium)
  ]

  timeouts {
    create = "1h30m"
    update = "2h"
    delete = "20m"
  }
}

