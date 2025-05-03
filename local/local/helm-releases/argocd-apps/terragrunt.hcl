include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "stack_common" {
  path   = "${get_repo_root()}/_common/helm-releases.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_uri}//${include.stack_common.locals.module_path}?ref=v0.0.4"

  # To use local modules:
  # source = "${get_repo_root()}/../terraform-base-modules/k8/helm-releases"
}

dependency "collection" {
  config_path = "../collection"
  skip_outputs = true
}

locals {
  label       = "argocd-apps"
  values_path = "."
}

inputs = {
  releases = {
    "${local.label}" = {
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "${local.label}"
      # version    = "2.0.2"
      namespace = "argocd"
      values    = ["${local.values_path}/values.yaml"]
    }
  }
}
