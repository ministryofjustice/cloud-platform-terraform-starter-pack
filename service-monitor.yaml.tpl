apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: hello-world-prometheus-servicemonitor
  namespace: ${namespace}
spec:
  endpoints:
  - interval: 15s
    port: https
  selector:
    matchLabels:
      app: helloworld

