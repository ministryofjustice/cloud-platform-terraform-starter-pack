terraform {
  required_version = ">= 1.2.5"
  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">=2.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.12.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.4.3"
    }
  }
}

