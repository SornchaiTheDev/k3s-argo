{
  newService(name, image, host=null, replicas=1, containerPort=3000, servicePort=80, entrypoints=['web', 'websecure']): {
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
    [if host != null then "ingress"]: {
      apiVersion: 'networking.k8s.io/v1',
      kind: 'Ingress',
      metadata: {
        name: name,
        annotations: {
          // Join the list of entrypoints into a comma-separated string for Traefik
          'traefik.ingress.kubernetes.io/router.entrypoints': std.join(',', entrypoints),
        },
      },
      spec: {
        // Traefik v3 standard: explicit Ingress Class Name
        ingressClassName: 'traefik',
        rules: [
          {
            host: h,
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
          }
          for h in (if std.isString(host) then [host] else host)
        ],
      },
    },
  },
}
