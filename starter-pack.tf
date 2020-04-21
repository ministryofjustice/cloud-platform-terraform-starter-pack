
resource "helm_release" "helloworld" {
  count      = var.helloworld ? 1 : 0
  name       = "helloworld"
  namespace  = var.namespace
  chart      = "helloworld"
  repository = data.helm_repository.cloud_platform.metadata[0].name
  values = [templatefile("${path.module}/templates/helloworld.yaml.tpl", {
      helloworld-ingress   = format(
      "%s-%s.%s.%s",
      "helloworld-app",
      var.namespace,
      "apps",
      data.terraform_remote_state.cluster.outputs.cluster_domain_name,
  )
  })]
  lifecycle {
    ignore_changes = [keyring]
  }
}


resource "random_password" "adminpassword" {
  length  = 16
  special = false
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "kubernetes_secret" "container_postgres_secrets" {
  count = var.enable_postgres_container ? 1 : 0
  metadata {
    name      = "container-postgres-secrets"
    namespace = var.namespace
  }

  data = {
    postgresql-postgres-password  = random_password.adminpassword.result
    postgresql-password = random_password.password.result
  }
  type = "Opaque"
}


resource "kubernetes_secret" "postgresurl_secret" {
  count = var.enable_postgres_container ? 1 : 0
  metadata {
    name      = "postgresurl-secret"
    namespace = var.namespace
  }

  data = {
    url = format(
      "%s%s:%s@%s.%s.%s",
      "postgres://",
      "postgres",
      kubernetes_secret.container_postgres_secrets[count.index].data.postgresql-password,
      "multi-container-app-postgresql",
      var.namespace,
      "svc.cluster.local:5432/multi_container_demo_app",
    )
  }
  type = "Opaque"
}

resource "helm_release" "multi-container-app" {
  count      = var.multi_container_app ? 1 : 0
  name       = "multi-container-app"
  namespace  = var.namespace
  chart      = "multi-container-app"
  repository = data.helm_repository.cloud_platform.metadata[0].name
  values = [templatefile("${path.module}/templates/multi-container-app.yaml.tpl", {
      multi-container-app-ingress   = format(
      "%s-%s.%s.%s",
      "multi-container-app",
      var.namespace,
      "apps",
      data.terraform_remote_state.cluster.outputs.cluster_domain_name,
  )
  
  postgres-enabled = var.enable_postgres_container

  postgres-secret = var.enable_postgres_container ? "postgresurl-secret" : var.rds_secret
  })]

  lifecycle {
    ignore_changes = [keyring]
  }
}
