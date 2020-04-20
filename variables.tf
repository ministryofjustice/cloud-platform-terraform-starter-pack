
variable "namespace" {
  default = "starter-pack"
}

variable "helloworld" {
  default = true
}

variable "multi_container_app" {
  default = true
}
variable "enable_postgres_container" {
  default = true
  description = "Enable postgres inside a container"
}

variable "rds_secret" {
  default = ""
  description = "kubernetes secret if using RDS for postgres"
}