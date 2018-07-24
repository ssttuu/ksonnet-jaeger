{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    jaeger: {
      containerPort: 16686,
      image: "jaegertracing/all-in-one:1.6",
      name: "jaeger",
      replicas: 1,
      servicePort: 80,
      type: "LoadBalancer",
    },
  },
}
