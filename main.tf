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
  depends_on = [kind_cluster.workshop]
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
  depends_on = [helm_release.cni]
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


