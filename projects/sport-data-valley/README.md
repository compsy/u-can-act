# Sport data valley
In order to connect to the base platform, use the following `.env.local` settings

```
PROJECT_NAME='sport-data-valley'

TOKEN_SIGNATURE_ALGORITHM=HS256
AUTH0_CLIENT_ID=''
AUTH0_SIGNING_CERTIFICATE='d434d8c85454ea40a82300a8e53386e95434551c063757f9c7f99a4938a15192336d9ca4d476cf1ab5757605948b2a32b22745d9957d198a6625b99e5108da9b'
AUTH0_AUDIENCE=''

HOST_URL=http://localhost:3010
HOST_DOMAIN=localhost
INFO_EMAIL=info@sport-data-valley.nl
FROM_EMAIL_ADDRESS=Sport Data Valley <sdvmvp@invite.researchable.nl>

SITE_LOCATION=http://localhost:3010

MAILGUN_API_KEY=SOMEHEXNUMBERHERE
MAILGUN_DOMAIN=invite.researchable.nl
MAILGUN_API_HOST=api.eu.mailgun.net
```

This may break some of the jwt-auth specs. If you want to run these while having this configuration, you need to uncomment some lines in `config/environments/test.rb`. See that file for more information.
