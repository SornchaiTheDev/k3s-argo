local base = import '../lib/service-template.jsonnet';

local app = base.newService(
  name='portfolio-2026',
  image='sornchaithedev/portfolio-2026:latest',
  host='sornchaithedev.com',
  containerPort=80,
);

std.objectValues(app)
