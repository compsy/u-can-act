# svc-questionnaires

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for SVC Questionnaires

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretName | string | `"svc-questionnaires-secret"` | The main secret for reading the environment variables for the questionnaire engine. |
| databaseSecretName | string | `"svc-questionnaires-database-credentials"` | The secret for storing the database credentials. Must have a key called `DATABASE_URL` that contains a single connection string. |
| redisSecretName | string | `"svc-questionnaires-redis-credentials"` | The secret for storing the redis credentials. Defaults to the same secret as stored in `secretName` Must have a key called `REDIS_URL` that contains a single connection string. |
| mongoSecretName | string | `"svc-questionnaires-mongo-credentials"` | The secret for storing the mongodb credentials. Defaults to the same secret as stored in `secretName` Must have a key called `MONGODB_URI` that contains a single connection string. |
| tag | string | `"latest"` | The tag of the questionnaire engine image to deploy. |
| appsignalAppEnv | string | `"staging"` | The environment of the AppSignal application. |
| curlImage | string | `"registry.gitlab.com/researchable/general/docker-images/curl:latest"` | The Docker image for the curl command used in the init container. |
| imagePullSecrets | list | `["gitlab-auth", "docker-auth"]` | List of image pull secrets used for pulling images from private registries. |
| memory.web.request | string | `"768Mi"` | The memory request for the web container. |
| memory.web.limit | string | `"1.5Gi"` | The memory limit for the web container. |
| memory.worker.request | string | `"768Mi"` | The memory request for the worker container. |
| memory.worker.limit | string | `"1.5Gi"` | The memory limit for the worker container. |
| configmap.PUSH_SUBSCRIPTION_URL | string | `"http://web:3000/api/v1/data/create_raw"` | URL to push subscription data. |
| configmap.BASE_PLATFORM_URL | string | `"http://localhost:3000"` | Base platform URL. |
| configmap.HOST_URL | string | `"http://localhost:3002"` | Host URL. |
| configmap.HOST_DOMAIN | string | `"localhost"` | Host domain. |
| configmap.INFO_EMAIL | string | `"info@vsv.io"` | Info email address. |
| configmap.FEEDBACK_EMAIL | string | `"feedback@u-can-act.nl"` | Feedback email address. |
| configmap.MESSAGEBIRD_SEND_FROM | string | `"u-can-act"` | Sender name for MessageBird messages. |
| configmap.FROM_EMAIL_ADDRESS | string | `"info@u-can-act.nl"` | From email address for emails sent by the app. |
| configmap.INFO_SITE_URL | string | `"https://u-can-act.nl"` | Information site URL. |
| configmap.RAILS_SERVE_STATIC_FILES | string | `"true"` | Whether Rails should serve static files. |
| configmap.PROJECT_NAME | string | `"u-can-act"` | Project name. |
| configmap.SITE_LOCATION | string | `"https://u-can-act.nl"` | Site location URL. |
| configmap.WEB_CONCURRENCY | string | `"2"` | Number of web processes to run. |
| configmap.RAILS_MAX_THREADS | string | `"5"` | Maximum number of Rails threads. |

## Testing the chart after changes

To test the chart after changes, run the following command in the root of the chart directory:

```bash
helm template svc-questionnaires . --namespace usc-chan-develop --values values.yaml > output.yaml
```
