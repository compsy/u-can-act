# aukati-svc-auth

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

Aukati SVC Auth chart

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configmap.ADD_TOKEN_TO_QUERY_PARAMS | string | `"true"` | App var, pass token to query params |
| configmap.ALLOWED_ORIGINS | string | `""` | App var, allowed origins including protocol |
| configmap.APPSIGNAL_APP_ENV | string | `"staging"` | App var, APM environment: production or staging |
| configmap.AUTH_COOKIE_HOST | string | `""` | App var, auth cookie host starts with doth |
| configmap.JWT_EXPIRATION_TIME | string | `"28800"` | App var, JWT expiration time in seconds |
| configmap.PORT | string | `"3000"` | App var, application port  |
| configmap.RACK_ENV | string | `"production"` |  |
| configmap.RAILS_ENV | string | `"production"` |  |
| configmap.SIGNIN_SUCCESS_CALLBACK | string | `""` | App var, signin callback url |
| image | string | `"docker.io/researchableuser/aukati-svc-auth:86908068"` | container image to use |
| imagePullSecrets | list | `[{"name":"docker-auth"}]` | secret containing credentials for the registry of `image` |
| ingress.annotations | object | `{"acme.cert-manager.io/http01-edit-in-place":"true","cert-manager.io/cluster-issuer":"letsencrypt-prod","nginx.ingress.kubernetes.io/proxy-body-size":"100m"}` | annotations added to the ingress |
| ingress.enabled | bool | `true` | enable the ingress |
| ingress.hosts | list | `[""]` | host for the ingress (also used for TLS) excluding protocol |
| ingress.tls | object | `{"enabled":true,"secretName":"svc-auth-tls"}` | secure with TLS |
| ingress.tls.secretName | string | `"svc-auth-tls"` | name of the kubernetes secret that stores the certificate |
| replicaCount | int | `2` | number of replicas for both the deployment and worker |
| secretName | string | `""` | Name of the secret that contains the env vars |

