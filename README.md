# cloud-platform-terraform-starter-pack
Terraform module that deploy Starter pack to a kubernetes cluster. This module is mainly for the Cloud Platform to use it in test clusters. 

## Usage

To use this module, you need to create the kubernetes namespace which is passed as a input to the module. 

```hcl

resource "kubernetes_namespace" "starter-pack" {
  metadata {
    name = "starter-pack"

    labels = {
      "name" = "starter-pack"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Cloud Platform starter pack test app"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
    }
  }
}
```

```hcl
module "starter_pack" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-starter-pack?ref=0.0.1"
  cluster_name         = var.cluster_name
  cluster_state_bucket = var.cluster_state_bucket
  namespace            = kubernetes_namespace.starter-pack.id
}
```

To create multiple instances of the starter pack, change the "starter-pack" string to a different name.
For example:

resource "kubernetes_namespace" "starter-pack-2" {
  metadata {
    name = "starter-pack-2"

    labels = {
      "name" = "starter-pack-2"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Cloud Platform starter pack test app"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
    }
  }
}
```

```hcl
module "starter_pack_2" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-starter-pack?ref=0.0.1"
  cluster_name         = var.cluster_name
  cluster_state_bucket = var.cluster_state_bucket
  namespace            = kubernetes_namespace.starter-pack-2.id
}
```

## Inputs

| Name                         | Description         | Type | Default | Required |
|------------------------------|---------------------|:----:|:-------:|:--------:|
| cluster_name                 | kubernetes cluster name where the app will be deployed  | string |  | yes |
| cluster_state_bucket         | State bucket of the cluster                             | string | | yes |
| namespace                    | namespace where the app will be deployed                | string | | no |
## Outputs

The module will deploy the [Hello World ruby app] (https://github.com/ministryofjustice/cloud-platform-helloworld-ruby-app) and [Multi container demo app] (https://github.com/ministryofjustice/cloud-platform-multi-container-demo-app) in the namespace "starter-pack"
