local base = import '../lib/service-template.jsonnet';

local app = base.newService(
  name='portfolio-2026',
  image='sornchaithedev/portfolio-2026:latest',
  host='sornchai.com',
  containerPort=3000,
);

std.objectValues(app)
