
variable "enable_starter_pack" {
  type        = bool
  default     = true
  description = "Enable/Disable the whole module - all resources"
}

variable "enable_postgres_container" {
  default     = true
  description = "Enable postgres inside a container"
  type        = bool
}

variable "namespace" {
  type    = string
  default = "starter-pack"
}

variable "helloworld" {
  default = true
  type    = bool
}

variable "multi_container_app" {
  default = true
  type    = bool
}


variable "rds_secret" {
  default     = ""
  type        = string
  description = "kubernetes secret if using RDS for postgres"
}