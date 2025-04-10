{{- define "container.env" }}
envFrom:
  - configMapRef:
      name: {{ .Release.Name }}-config
env:
  - name: RAILS_ENV
    value: production
  - name: RACK_ENV
    value: production
  - name: NODE_ENV
    value: production
  - name: REVISION
    value: {{ .Release.Revision | quote }}
  - name: APPSIGNAL_APP_ENV
    value: {{ .Values.appsignalAppEnv }}
  - name: APPSIGNAL_ACTIVE
    value: "true"
  - name: APPSIGNAL_PUSH_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: APPSIGNAL_PUSH_API_KEY
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: {{ .Values.databaseSecretName | default .Values.secretName }}
        key: {{ .Values.databaseSecretKey }}
  - name: SECRET_KEY_BASE
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: SECRET_KEY_BASE
  - name: MESSAGEBIRD_ACCESS_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: MESSAGEBIRD_ACCESS_KEY
  - name: MESSAGEBIRD_SEND_FROM
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: MESSAGEBIRD_SEND_FROM
  - name: PERSON_SALT
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: PERSON_SALT
  - name: STOP_SUBSCRIPTION_SALT
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: STOP_SUBSCRIPTION_SALT
  - name: ADMIN_USERNAME
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: ADMIN_USERNAME
  - name: ADMIN_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: ADMIN_PASSWORD
  - name: MAILGUN_API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: MAILGUN_API_KEY
  - name: MAILGUN_DOMAIN
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: MAILGUN_DOMAIN
  - name: AUTH0_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_CLIENT_ID
  - name: AUTH0_DOMAIN
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_DOMAIN
  - name: AUTH0_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_CLIENT_SECRET
  - name: AUTH0_REDIRECT_URL
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_REDIRECT_URL
  - name: AUTH0_AUDIENCE
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_AUDIENCE
  - name: AUTH0_SIGNING_CERTIFICATE
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: AUTH0_SIGNING_CERTIFICATE
  - name: REDIS_URL
    valueFrom:
      secretKeyRef:
        name: {{ .Values.redisSecretName | default .Values.secretName }}
        key: {{ .Values.redisSecretKey }}
  - name: TEST_PHONE_NUMBERS
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: TEST_PHONE_NUMBERS
  - name: SNITCH_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: SNITCH_KEY
  - name: API_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: API_KEY
  - name: API_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: API_SECRET
  - name: IP_HASH_SALT
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: IP_HASH_SALT
  - name: MAILGUN_API_HOST
    valueFrom:
      secretKeyRef:
        name: {{ .Values.secretName }}
        key: MAILGUN_API_HOST
  - name: MONGODB_URI
    valueFrom:
      secretKeyRef:
        name: {{ .Values.mongoSecretName | default .Values.secretName }}
        key: {{ .Values.mongoSecretKey }}
  - name: TOKEN_SIGNATURE_ALGORITHM
    valueFrom:
      secretKeyRef:
        name: {{ .Values.authSecretName | default .Values.secretName }}
        key: {{ .Values.authSignatureAlgorithmKey | default "TOKEN_SIGNATURE_ALGORITHM" }}
  - name: DEVISE_JWT_SECRET_KEY
    valueFrom:
      secretKeyRef:
        name: {{ .Values.authSigningSecretName | default .Values.authSecretName | default .Values.secretName }}
        key: {{ .Values.authSigningSecretKey | default "DEVISE_JWT_SECRET_KEY" }}
  - name: JWT_DECODING_SECRET
    valueFrom:
      secretKeyRef:
        name: {{ .Values.authDecodingSecretName | default .Values.authSecretName | default .Values.secretName }}
        key: {{ .Values.authDecodingSecretKey | default "JWT_DECODING_SECRET"}}
{{- end }}
