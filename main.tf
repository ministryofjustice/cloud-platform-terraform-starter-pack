
data "helm_repository" "cloud_platform" {
  name = "cloud-platform"
  url  = "https://ministryofjustice.github.io/cloud-platform-helm-charts"
}

# Namespace

resource "kubernetes_namespace" "starter_pack" {
  count = var.enable_starter_pack ? 1 : 0

  metadata {
    name = var.namespace

    labels = {
      "name" = var.namespace
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Cloud Platform starter pack test app"
      "cloud-platform.justice.gov.uk/business-unit" = "cloud-platform"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
    }
  }
}

resource "random_password" "adminpassword" {
  count = var.enable_starter_pack ? 1 : 0

  length  = 16
  special = false
}

resource "random_password" "password" {
  count = var.enable_starter_pack ? 1 : 0

  length  = 16
  special = false
}

resource "kubernetes_secret" "container_postgres_secrets" {
  count = var.enable_postgres_container && var.enable_starter_pack ? 1 : 0

  metadata {
    name      = "container-postgres-secrets"
    namespace = kubernetes_namespace.starter_pack.0.id
  }

  data = {
    postgresql-postgres-password = random_password.adminpassword.0.result
    postgresql-password          = random_password.password.0.result
  }
  type = "Opaque"
}

resource "kubernetes_secret" "postgresurl_secret" {
  count = var.enable_postgres_container && var.enable_starter_pack ? 1 : 0

  type = "Opaque"

  metadata {
    name      = "postgresurl-secret"
    namespace = kubernetes_namespace.starter_pack.0.id
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
}

resource "helm_release" "helloworld" {
  count = var.helloworld && var.enable_starter_pack ? 1 : 0

  name       = "helloworld"
  namespace  = kubernetes_namespace.starter_pack.0.id
  chart      = "helloworld"
  repository = data.helm_repository.cloud_platform.metadata[0].name

  values = [templatefile("${path.module}/templates/helloworld.yaml.tpl", {
    helloworld-ingress = format(
      "%s-%s.%s.%s",
      "helloworld-app",
      var.namespace,
      "apps",
      var.cluster_domain_name,
    )
  })]

  depends_on = [
    var.dependence_deploy
  ]
}

resource "helm_release" "multi_container_app" {
  count = var.multi_container_app && var.enable_starter_pack ? 1 : 0

  name       = "multi-container-app"
  namespace  = kubernetes_namespace.starter_pack.0.id
  chart      = "multi-container-app"
  repository = data.helm_repository.cloud_platform.metadata[0].name

  values = [templatefile("${path.module}/templates/multi-container-app.yaml.tpl", {
    multi-container-app-ingress = format(
      "%s-%s.%s.%s",
      "multi-container-app",
      var.namespace,
      "apps",
      var.cluster_domain_name,
    )

    postgres-enabled = var.enable_postgres_container
    postgres-secret  = var.enable_postgres_container ? "postgresurl-secret" : var.rds_secret
  })]

  depends_on = [
    var.dependence_deploy
  ]

}
