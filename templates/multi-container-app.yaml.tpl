# Default values for multi-container-app.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

databaseUrlSecretName: "${ postgres-secret }"
contentapiurl: "http://content-api-service:4567/image_url.json"
                
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: "${ multi-container-app-ingress }"
      paths: []
  # Update tls for custom domain and update secretName where certificate is stored
  # tls:
  #   - secretName: <CERTIFICATE-SECRET-NAME>
  #     hosts:
  #       - <DNS-PREFIX>.apps.live-1.cloud-platform.service.justice.gov.uk
    
postgresql:
  enabled: true
  existingSecret: container-postgres-secrets
  postgresqlDatabase: multi_container_demo_app
  persistence:
    enabled: false

contentapi:
  replicaCount: 1
  image:
    repository: ministryofjustice/cloud-platform-multi-container-demo-app
    tag: content-api-1.4
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 4567
    targetPort: 4567

railsapp:
  replicaCount: 1
  image:
    repository: ministryofjustice/cloud-platform-multi-container-demo-app
    tag: rails-app-1.4
    pullPolicy: IfNotPresent
  containerPort: 3000
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""
  service:
    type: ClusterIP
    port: 3000
    targetPort: 3000
  job:
    backoffLimit: 4
    restartPolicy: OnFailure

worker:
  replicaCount: 1
  image:
    repository: ministryofjustice/cloud-platform-multi-container-demo-app
    tag: worker-1.4
    pullPolicy: IfNotPresent
  containerPort: 4567
  imagePullSecrets: []
  nameOverride: ""
  fullnameOverride: ""