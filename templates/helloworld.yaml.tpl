# Default values for helm_deploy.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

ingress:
  className: modsec
  hosts:
    - host: "${ helloworld-ingress }"
  
