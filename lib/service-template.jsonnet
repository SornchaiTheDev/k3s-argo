{
  newService(name, image, replicas=1, port=8080): {
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
              ports: [{ containerPort: port }],
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
        ports: [{ port: 80, targetPort: port }],
      },
    },
  },
}
