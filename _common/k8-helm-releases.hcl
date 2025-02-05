locals {
  module_path = "k8/helm-releases"
  ref         = "v0.0.3"
}

inputs = {
  helm_provider = {
    config_path    = "~/.kube/config"
    config_context = "k8lab"
  }
}

generate "terraform" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}
EOF
}
