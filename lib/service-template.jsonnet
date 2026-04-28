{
  newService(name, image, host=null, replicas=1, containerPort=3000, servicePort=80): {
    deployment: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      metadata: { name: name },
      spec: {
        replicas: replicas,
        selector: { matchLabels: { app: name } },
        template: {
          metadata: { labels: { app: name } },
          spec: {
            containers: [{
              name: name,
              image: image,
              ports: [{ containerPort: containerPort }],
            }],
          },
        },
      },
    },
    service: {
      apiVersion: 'v1',
      kind: 'Service',
      metadata: { name: name },
      spec: {
        selector: { app: name },
        ports: [{ port: servicePort, targetPort: containerPort }],
      },
    },
    // Only generate Ingress if a host is provided
    [if host != null then "ingress"]: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: {
        name: name,
        annotations: {
          'kubernetes.io/ingress.class': 'traefik',
          'traefik.ingress.kubernetes.io/router.entrypoints': 'web',
        },
      },
      spec: {
        rules: [{
          host: host,
          http: {
            paths: [{
              path: '/',
              pathType: 'Prefix',
              backend: {
                service: {
                  name: name,
                  port: { number: servicePort },
                },
              },
            }],
          },
        }],
      },
    },
  },
}
