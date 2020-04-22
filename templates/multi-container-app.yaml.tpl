# Default values for multi-container-app.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

databaseUrlSecretName: "${ postgres-secret }"
                
ingress:
  hosts:
    - host: "${ multi-container-app-ingress }"

postgresql:
  enabled: ${ postgres-enabled }