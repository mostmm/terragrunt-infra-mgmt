include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "stack_common" {
  # path   = "${get_repo_root()}/_common/${basename(get_terragrunt_dir())}.hcl"
  path   = "${get_repo_root()}/_common/helm-releases.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_uri}//${include.stack_common.locals.module_path}?ref=v0.0.4"

  # To use local modules:
  # source = "${get_repo_root()}/../terraform-base-modules/helm-releases"
}

locals {
  values_path = "values"
}

inputs = {
  releases = {
    "prometheus" = {
      repository = "https://prometheus-community.github.io/helm-charts"
      chart      = "kube-prometheus-stack"
      namespace  = "monitoring"
      values     = ["${local.values_path}/kube-prometheus-stack.yaml"]
    },
    "argocd" = {
      repository = "https://argoproj.github.io/argo-helm"
      chart      = "argo-cd"
      namespace  = "argocd"
      values     = ["${local.values_path}/argocd.yaml"]
      set_sensitive = {
        "configs.secret.extra.dex\\.github\\.clientSecret"                 = get_env("DEX_GITHUB_CLIENT_SECRET")
        "configs.credentialTemplates.github-app-creds.githubAppPrivateKey" = get_env("GITHUB_APP_PRIVATE_KEY")
      }
    },
    "keycloak" = {
      repository = "oci://registry-1.docker.io/bitnamicharts"
      chart      = "keycloak"
      version    = "24.4.13"
      namespace  = "keycloak"
      values     = ["${local.values_path}/keycloak.yaml"]
    }
  }
}
