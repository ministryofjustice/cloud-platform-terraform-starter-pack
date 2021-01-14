# cloud-platform-terraform-starter-pack
Terraform module that deploy Starter pack to a kubernetes cluster. This module is mainly for the Cloud Platform to use it in test clusters. 

This module will create a namespace `starter-pack-0` and deploy [helloworld](https://github.com/ministryofjustice/cloud-platform-helm-charts/tree/main/helloworld) and [multicontainer](https://github.com/ministryofjustice/cloud-platform-helm-charts/tree/main/multi-container-app) app.

## Usage

To use this module, see example below. 
```hcl
module "starter_pack" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-starter-pack?ref=0.1.0"

  enable_starter_pack = terraform.workspace == local.live_workspace ? false : true
  cluster_domain_name = data.terraform_remote_state.cluster.outputs.cluster_domain_name

  # To create more than one starter pack resources
  # starter_pack_count = 3
}

```

## Inputs

| Name                         | Description         | Type | Default | Required |
|------------------------------|---------------------|:----:|:-------:|:--------:|
| enable_starter_pack  | Enable/Disable the whole module - all resources | bool | true | no |
| cluster_domain_name | The cluster domain used for externalDNS annotations and certmanager | bool | true | no |
| enable_postgres_container | Enable postgres container for multi container app | bool | true | no |
| namespace | Namespace name appending the `count.index` mentioned in starter_pack_count | string | starter-pack | no |
| helloworld | Enable helloworld app in the starter pack | bool | true | no |
| multi_container_app | Enable MultiContainer app in starter pack | bool | true | no |
| rds_secret | RDS secret name if `enable_postgres_container` set to false and RDS is used for postgres | string | null | no |
| starter_pack_count | The number of starter pack needs to be created | number | 1 | no | 

## Outputs

The module will deploy the [Hello World ruby app](https://github.com/ministryofjustice/cloud-platform-helloworld-ruby-app) and [Multi container demo app](https://github.com/ministryofjustice/cloud-platform-multi-container-demo-app) in the namespace "starter-pack"
