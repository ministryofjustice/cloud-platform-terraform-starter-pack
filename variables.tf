
variable "namespace" {
  default = "starter-pack"
}

variable "helloworld" {
  default = true
  type = bool
}

variable "multi_container_app" {
  default = true
  type = bool
}
variable "enable_postgres_container" {
  default     = true
  description = "Enable postgres inside a container"
  type = bool
}


variable "rds_secret" {
  default     = ""
  description = "kubernetes secret if using RDS for postgres"
}