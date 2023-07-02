resource "kind_cluster" "workshop" {
  name   = "kind-cluster-workshop"
  config = file("${path.root}/clusters/kind.yml")
}
