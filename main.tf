resource "docker_network" "kind" {
  name = "kind"
  ipam_config {
    subnet = var.kind-network-subnet
  }
}

resource "kind_cluster" "workshop" {
  depends_on = [docker_network.kind]
  name       = "cluster-workshop"
  config     = file("${path.root}/clusters/kind.yml")
}

resource "helm_release" "cni" {
  name             = "cilium"
  repository       = "https://helm.cilium.io"
  chart            = "cilium"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  namespace        = "kube-system"
  timeout          = 600
  values = [
    templatefile("${path.root}/charts/cilium.yml", var.cilium)
  ]
  depends_on = [kind_cluster.workshop]
}


resource "helm_release" "mettallb" {
  name             = "metallb"
  chart            = "metallb"
  repository       = "https://metallb.github.io/metallb"
  namespace        = "metallb-system"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  provisioner "local-exec" {
    working_dir = path.root
    command     = " kubectl -n metallb-system apply -f resources/mettallb.yml"
  }
  depends_on = [helm_release.cni]
}

resource "helm_release" "istio" {

  name             = "istio"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  namespace        = "istio-system"
  # values = [
  #   templatefile("", "")
  # ]
  depends_on = [helm_release.mettallb]
}


resource "helm_release" "istiod" {

  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  namespace        = "istio-system"
  # values = [
  #   templatefile("", "")
  # ]
  depends_on = [helm_release.istio]
}

resource "helm_release" "istio_ingress" {

  name             = "istio-ingress"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  namespace        = "istio-ingress"
  # values = [
  #   templatefile("", "")
  # ]
  depends_on = [helm_release.istio]
}


