include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "stack_common" {
  path   = "${dirname(find_in_parent_folders())}/_common/${basename(get_terragrunt_dir())}.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_uri}//${include.stack_common.locals.module_path}?ref=${include.stack_common.locals.ref}"
}

locals {
  values_path = "values"
}

inputs = {
  releases = [
    {
      name       = "prometheus-stack"
      repository = "https://prometheus-community.github.io/helm-charts"
      chart      = "kube-prometheus-stack"
      namespace  = "monitoring"
      # values     = ["${local.values_path}/kube-prometheus-stack.yaml"]
    },
    {
      name       = "argocd"
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "argo-cd"
      version    = "5.52.2"
      namespace  = "argocd"
      values     = ["${local.values_path}/argocd.yaml"]
    }
  ]
}
