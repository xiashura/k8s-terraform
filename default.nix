with (import <nixpkgs> { });
let
in stdenv.mkDerivation {

  KUBECONFIG = "config.yml";

  shellHook = ''
    export VAULT_TOKEN=$(jq -r ".root_token" cluster-keys.json)
  '';

  name = "k8s-metallb-ingress";
  buildInputs =
    [ k9s kind terraform kubectl cilium-cli vault kubernetes-helm-wrapped ];
}
