# cloud-platform-terraform-starter-pack
Terraform module that deploy Starter pack to a kubernetes cluster. This module is mainly for the Cloud Platform to use it in test clusters. 

## Usage

To use this module, you need to create the kubernetes namespace which is passed as a input to the module. 

```hcl
module "starter_pack" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-starter-pack?ref=0.0.3"

  enable_starter_pack = terraform.workspace == local.live_workspace ? false : true
  cluster_domain_name = data.terraform_remote_state.cluster.outputs.cluster_domain_name
}

```

To create multiple instances of the starter pack, change the "starter-pack" string to a different name.
For example:


```hcl 

module "starter_pack_2" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-starter-pack?ref=0.0.1"

  cluster_name         = var.cluster_name
  namespace            = kubernetes_namespace.starter-pack-2.id
  cluster_domain_name  = data.terraform_remote_state.cluster.outputs.cluster_domain_name
}
```

## Inputs

| Name                         | Description         | Type | Default | Required |
|------------------------------|---------------------|:----:|:-------:|:--------:|
| cluster_name                 | kubernetes cluster name where the app will be deployed  | string |  | yes |
| enable_starter_pack          | Enable/Disable the whole module - all resources         | bool | true | no |
| cluster_domain_name          | The cluster domain used for externalDNS annotations and certmanager | bool | true | no |
| cluster_state_bucket         | State bucket of the cluster                             | string | | yes |
| namespace                    | namespace where the app will be deployed                | string | | no |
| rds-secret                    | Name of the secret where RDS credentials are stored               | string | | no |

## Outputs

The module will deploy the [Hello World ruby app] (https://github.com/ministryofjustice/cloud-platform-helloworld-ruby-app) and [Multi container demo app] (https://github.com/ministryofjustice/cloud-platform-multi-container-demo-app) in the namespace "starter-pack"
