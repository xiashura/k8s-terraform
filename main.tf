resource "docker_network" "kind" {
  name = "kind"
  ipam_config {
    subnet = var.kind-network-subnet
  }

  lifecycle {
    ignore_changes = [
      ipam_config,
    ]
  }
}

resource "kind_cluster" "workshop" {
  depends_on = [docker_network.kind]
  name       = "cluster-workshop"
  config     = file("${path.root}/clusters/${var.kind-cluster}")
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

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server"

  set {
    name  = "args"
    value = "{--kubelet-insecure-tls}"
  }

  depends_on = [
    helm_release.cni
  ]
}


resource "helm_release" "istio" {

  count = var.istio == true ? 1 : 0

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

  count = var.istio == true ? 1 : 0

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

  count = var.istio == true ? 1 : 0

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

resource "helm_release" "ingress-nginx" {

	depends_on = [ helm_release.mettallb ]

  count = var.ingress-nginx == true ? 1 : 0

  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
}

resource "helm_release" "argocd" {
  count = var.argocd == true ? 1 : 0

  depends_on = [
    helm_release.ingress-nginx,
  ]

  name             = "argocd"
  chart            = "argo-cd"
  repository       = "oci://ghcr.io/argoproj/argo-helm"
  namespace        = "argocd"
  create_namespace = true

  values = [
    templatefile("${path.root}/charts/argocd/value.yml", {})
  ]
}

resource "helm_release" "vault" {
  depends_on = [
    helm_release.ingress-nginx,
  ]

  count            = var.vault == true ? 1 : 0
  name             = "vault"
  chart            = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  namespace        = "vault"
  create_namespace = true

  values = [
    templatefile("${path.root}/charts/vault.yml", {})
  ]
}



