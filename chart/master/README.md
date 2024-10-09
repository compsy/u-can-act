# svc-questionnaires

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for SVC Questionnaires

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| secretName | string | `"svc-questionnaires-secret"` | The main secret for reading the environment variables for the questionnaire engine. |
| gitlabAuthSecretName | string | `"gitlab-auth"` | The secret used for pulling the curl image from docker-images on Researchable Gitlab. |
| dockerAuthSecretName | string | `"docker-auth"` | The secret used for pulling the questionnaire engine image from Dockerhub. |
| tag | string | `"latest"` | The tag of the questionnaire engine image to deploy. |
| namespace | string | `"usc-chan"` | The Kubernetes namespace to deploy the questionnaire engine charts to. |
| commitSha | string | `some-commit-sha` | The commit sha of the questionnaire engine image, used for distinguishing between different deploys on AppSignal. Sets the `REVISION` environment variable. |
| appsignalAppEnv | string | `"production"` | The environment of the AppSignal application. |
