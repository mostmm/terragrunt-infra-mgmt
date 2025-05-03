locals {
  module_path = "k8/helm-releases"
  ref         = "v0.0.3"
}

inputs = {}

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

generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "local"
  }
}
EOF
}
