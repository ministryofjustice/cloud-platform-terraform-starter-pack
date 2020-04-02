

data "template_file" "helloworld_deploy" {
  template = "${file("${path.module}/templates/helloworld-rubyapp/deploy.yaml")}"

  vars = {
    helloworld-rubyapp-ingress = format(
      "%s-%s.%s.%s",
      "helloworld-app",
      var.namespace,
      "apps",
      data.terraform_remote_state.cluster.outputs.cluster_domain_name,
  ) }

}

resource "null_resource" "helloworld_deploy" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.helloworld_deploy.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} apply -f -<<EOF\n${data.template_file.helloworld_deploy.rendered}\nEOF"
  }
}


resource "random_id" "user" {
  byte_length = 8
}

resource "random_id" "password" {
  byte_length = 8
}

resource "kubernetes_secret" "postgres_secrets" {
  metadata {
    name      = "postgres-credentials"
    namespace = var.namespace
  }

  data = {
    user     = random_id.user.hex
    password = random_id.password.hex
  }
  type = "Opaque"
}


data "template_file" "postgres_deploy" {
  template = "${file("${path.module}/templates/multi-container-app/pg-deploy.yaml")}"
  vars = {
    postgres_user     = kubernetes_secret.postgres_secrets.data.user
    postgres_password = kubernetes_secret.postgres_secrets.data.password
  }
}

resource "null_resource" "postgres_deploy" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.postgres_deploy.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} apply -f -<<EOF\n${data.template_file.postgres_deploy.rendered}\nEOF"
  }
}

#  postgres://dummy:dummy@multi-container-demo-postgres.starter-pack.svc.cluster.local:5432/multi_container_demo_app


data "template_file" "multi_container_app_deploy" {
  template = "${file("${path.module}/templates/multi-container-app/deploy.yaml")}"

  vars = {
    multi-container-app-ingress = format(
      "%s-%s.%s.%s",
      "multi-container-app",
      var.namespace,
      "apps",
      data.terraform_remote_state.cluster.outputs.cluster_domain_name,
    )
    postgres-url = format(
      "%s%s:%s@%s.%s.%s",
      "postgres://",
      kubernetes_secret.postgres_secrets.data.user,
      kubernetes_secret.postgres_secrets.data.password,
      "multi-container-demo-postgres",
      var.namespace,
      "svc.cluster.local:5432/multi_container_demo_app",
    )
  }
}

resource "null_resource" "multi_container_app_deploy" {
  triggers = {
    manifest_sha1 = "${sha1("${data.template_file.multi_container_app_deploy.rendered}")}"
  }

  provisioner "local-exec" {
    command = "kubectl -n ${var.namespace} apply -f -<<EOF\n${data.template_file.multi_container_app_deploy.rendered}\nEOF"
  }
}



