local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components.jaeger;
[
   {
      "apiVersion": "v1",
      "kind": "Service",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "ports": [
            {
               "name": "query-http",
               "port": params.servicePort,
               "protocol": "TCP",
               "targetPort": params.containerPort
            }
         ],
         "selector": {
            "app": params.name
         },
         "type": params.type
      }
   },
   {
      "apiVersion": "apps/v1beta2",
      "kind": "Deployment",
      "metadata": {
         "name": params.name
      },
      "spec": {
         "replicas": params.replicas,
         "strategy": {
            "type": "Recreate"
         },
         "selector": {
            "matchLabels": {
               "app": params.name
            },
         },
         "template": {
            "metadata": {
               "labels": {
                  "app": params.name
               }
            },
            "spec": {
               "containers": [
                  {
                     "image": params.image,
                     "name": params.name,
                     "ports": [
                        {
                            "containerPort": 5775,
                            "protocol": "UDP"
                        },
                        {
                            "containerPort": 6831,
                            "protocol": "UDP"
                        },
                        {
                            "containerPort": 6832,
                            "protocol": "UDP"
                        },
                        {
                            "containerPort": 5778,
                            "protocol": "TCP"
                        },
                        {
                            "containerPort": params.containerPort,
                            "protocol": "TCP"
                        },
                        {
                            "containerPort": 9411,
                            "protocol": "TCP"
                        }
                     ],
                     "env": [
                        {
                            "name": "COLLECTOR_ZIPKIN_HTTP_PORT",
                            "value": "9411"
                        }
                     ],
                     "readinessProbe": {
                        "httpGet": {
                            "path": "/",
                            "port": 14269
                        },
                        "initialDelaySeconds": 5
                     }
                  }
               ]
            }
         }
      }
   }
]
