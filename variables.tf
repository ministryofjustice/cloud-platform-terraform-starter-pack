variable "cluster_name" {
  description = "The name of the cluster (eg.: test-1)"
}

variable "cluster_state_bucket" {
  description = "The name of the S3 bucket holding the terraform state for the cluster"
}

variable "namespace" {
  default = "starter-pack"
}

