# myTinyTodo Helm Chart

A Helm chart for deploying myTinyTodo, a tiny self-hosted todo application, on Kubernetes with PostgreSQL.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.8.0+
- PV provisioner support in the underlying infrastructure (for PostgreSQL persistence)

## Installing the Chart

To install the chart with the release name `my-mytinytodo`:

```bash
# Add the Bitnami repository (for PostgreSQL dependency)
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install the chart
helm install my-mytinytodo ./helm/mytinytodo
```

This command deploys myTinyTodo on the Kubernetes cluster with the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-mytinytodo` deployment:

```bash
helm uninstall my-mytinytodo
```

This command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `nameOverride`            | String to partially override mytinytodo.fullname | `""`  |
| `fullnameOverride`        | String to fully override mytinytodo.fullname   | `""`  |

### Image parameters

| Name                | Description                          | Value        |
| ------------------- | ------------------------------------ | ------------ |
| `image.repository`  | myTinyTodo image repository          | `mytinytodo` |
| `image.tag`         | myTinyTodo image tag                 | `latest`     |
| `image.pullPolicy`  | myTinyTodo image pull policy         | `IfNotPresent` |
| `imagePullSecrets`  | myTinyTodo image pull secrets        | `[]`         |

### Deployment parameters

| Name                        | Description                               | Value |
| --------------------------- | ----------------------------------------- | ----- |
| `replicaCount`              | Number of myTinyTodo replicas to deploy   | `1`   |
| `podAnnotations`            | Annotations for myTinyTodo pods           | `{}`  |
| `podSecurityContext`        | Configure myTinyTodo pods' Security Context | `{}`  |
| `securityContext`           | Configure myTinyTodo containers' Security Context | `{}` |

### Service parameters

| Name                 | Description                                          | Value       |
| -------------------- | ---------------------------------------------------- | ----------- |
| `service.type`       | myTinyTodo service type                              | `ClusterIP` |
| `service.port`       | myTinyTodo service HTTP port                         | `80`        |
| `service.targetPort` | myTinyTodo service HTTP target port                  | `80`        |

### Ingress parameters

| Name                       | Description                                        | Value   |
| -------------------------- | -------------------------------------------------- | ------- |
| `ingress.enabled`          | Enable ingress record generation for myTinyTodo   | `false` |
| `ingress.className`        | IngressClass that will be used to implement the Ingress | `""` |
| `ingress.annotations`      | Additional annotations for the Ingress resource   | `{}`    |
| `ingress.hosts`            | An array with hosts and paths                      | `[{"host": "mytinytodo.local", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `ingress.tls`              | TLS configuration for myTinyTodo ingress          | `[]`    |

### Resource limits

| Name                        | Description                                     | Value   |
| --------------------------- | ----------------------------------------------- | ------- |
| `resources.limits`          | The resources limits for the myTinyTodo containers | `{}`    |
| `resources.requests`        | The requested resources for the myTinyTodo containers | `{}`    |

### Autoscaling parameters

| Name                                            | Description                                                                                                          | Value   |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                           | Enable Horizontal POD autoscaling for myTinyTodo                                                                    | `false` |
| `autoscaling.minReplicas`                       | Minimum number of myTinyTodo replicas                                                                               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of myTinyTodo replicas                                                                               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                   | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                | `""`    |

### Application configuration

| Name                              | Description                           | Value      |
| --------------------------------- | ------------------------------------- | ---------- |
| `config.database.type`            | Database type                         | `postgres` |
| `config.database.host`            | Database host                         | `""`       |
| `config.database.port`            | Database port                         | `5432`     |
| `config.database.name`            | Database name                         | `mytinytodo` |
| `config.database.user`            | Database user                         | `mytinytodo` |
| `config.database.password`        | Database password                     | `""`       |
| `config.database.prefix`          | Database table prefix                 | `mtt_`     |
| `config.app.salt`                 | Application salt for security         | `""`       |
| `config.app.debug`                | Enable debug mode                     | `false`    |
| `config.app.disableExtensions`    | Disable application extensions        | `false`    |
| `config.app.apiUsePathInfo`       | Use PATH_INFO for API routing         | `false`    |

### PostgreSQL parameters

| Name                                          | Description                                        | Value        |
| --------------------------------------------- | -------------------------------------------------- | ------------ |
| `postgresql.enabled`                          | Switch to enable or disable the PostgreSQL helm chart | `true`   |
| `postgresql.auth.postgresPassword`           | Password for the "postgres" admin user            | `""`         |
| `postgresql.auth.username`                   | Name for a custom user to create                  | `mytinytodo` |
| `postgresql.auth.password`                   | Password for the custom user to create            | `""`         |
| `postgresql.auth.database`                   | Name for a custom database to create              | `mytinytodo` |
| `postgresql.primary.persistence.enabled`     | Enable PostgreSQL Primary data persistence using PVC | `true`    |
| `postgresql.primary.persistence.size`        | PVC Storage Request for PostgreSQL volume         | `8Gi`        |

### External Database parameters

| Name                                         | Description                                                      | Value                    |
| -------------------------------------------- | ---------------------------------------------------------------- | ------------------------ |
| `externalDatabase.host`                      | External PostgreSQL host                                         | `""`                     |
| `externalDatabase.port`                      | External PostgreSQL port                                         | `5432`                   |
| `externalDatabase.username`                  | External PostgreSQL username                                     | `mytinytodo`             |
| `externalDatabase.password`                  | External PostgreSQL password                                     | `""`                     |
| `externalDatabase.database`                  | External PostgreSQL database name                               | `mytinytodo`             |
| `externalDatabase.existingSecret`            | The name of an existing secret with PostgreSQL credentials      | `""`                     |
| `externalDatabase.existingSecretPasswordKey` | The key in the existing secret containing the PostgreSQL password | `postgresql-password`    |

## Configuration and installation details

### Rolling VS Immutable tags

It is strongly recommended to use immutable tags in a production environment. This ensures that your deployment does not change automatically if a new version of the image is pushed to the registry.

### Setting Pod's affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod's affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

### Deploying extra resources

There are cases where you may want to deploy extra objects, such as KongPlugins, KongConsumers, amongst others. For covering this case, the chart allows adding the full specification of other objects using the `extraDeploy` parameter.

## Examples

### Installing with custom values

```bash
# Create a custom values file
cat > my-values.yaml << EOF
ingress:
  enabled: true
  hosts:
    - host: todo.example.com
      paths:
        - path: /
          pathType: Prefix

postgresql:
  auth:
    password: "my-secure-password"

resources:
  requests:
    memory: 256Mi
    cpu: 200m
  limits:
    memory: 512Mi
    cpu: 500m
EOF

# Install with custom values
helm install my-mytinytodo ./helm/mytinytodo -f my-values.yaml
```

### Using an external PostgreSQL database

```bash
helm install my-mytinytodo ./helm/mytinytodo \
  --set postgresql.enabled=false \
  --set externalDatabase.host=my-postgres.example.com \
  --set externalDatabase.username=mytinytodo \
  --set externalDatabase.password=secretpassword \
  --set externalDatabase.database=mytinytodo
```

### Enabling persistence

```bash
helm install my-mytinytodo ./helm/mytinytodo \
  --set persistence.enabled=true \
  --set persistence.size=2Gi
```