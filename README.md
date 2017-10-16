# VSV
Ruby Application for the Vroegtijdig School Verlaten Dagboekonderzoek

[![Circle CI][circleci-image]][circleci-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![Dependency Status][gemnasium-image]][gemnasium-url]


## Installation
Create checkout and install dependencies
```bash
  git clone git@github.com:compsy/vsv.git
  cd vsv
  bundle
```

Initialize the database
``` ruby
  bundle exec rake db:setup
```

## Dependencies
The VSV application has the following dependencies:
- PostgreSQL

## Configuration
The .env.local file is used for storing all ENV variables. Below is a list of all required ENV variables.

### General settings
```
  SECRET_KEY_BASE: <base used for the tokens>
  HOST_URL: <the url where the application is hosted (e.g. http://myapp.dev)>
  HOST_DOMAIN: <just the domain part of HOST_URL (e.g. myapp.dev)>
  INFO_EMAIL: <email address to use as sender for user account emails>
  PROJECT_NAME: <name of the project (e.g. Vsv)>

  MESSAGEBIRD_ACCESS_KEY: <access key for messagebird>
  MESSAGEBIRD_SEND_FROM: <sender name shown for SMS>

  PERSON_SALT: <salt used to hash person ids in the exporter>

  ADMIN_USERNAME: <user name for the admin panel>
  ADMIN_PASSWORD: <password for the admin panel>
```

## Background jobs
The workings of the app rely on three background jobs:

Every 15 minutes, the following rake task should run:
```
rake scheduler:send_invitations
```

Daily (e.g., at 3am), the following rake task should run:
```
rake scheduler:complete_protocol_subscriptions
```

Daily (e.g., at 4am), the following rake task should run:
```
rake scheduler:cleanup_invitation_tokens
```

In addition, a `delayed_job` worker should be available at all times. These can be started with `bin/delayed_job start`.


## Variables that can be used in texts:

```ruby
        VARIABLE                    DEFAULT VALUE           EXAMPLE
        =======================================================================
        begeleider                  begeleider              s-team captain
        Begeleider                  Begeleider              S-team captain
        zijn_haar_begeleider        zijn/haar               haar
        Zijn_haar_begeleider        Zijn/haar               Haar
        hij_zij_begeleider          hij/zij                 zij
        Hij_zij_begeleider          Hij/zij                 Zij
        deze_student                deze student            Rik
        Deze_student                Deze student            Rik
        zijn_haar_student           zijn/haar               zijn
        Zijn_haar_student           Zijn/haar               Zijn
        hij_zij_student             hij/zij                 hij
        Hij_zij_student             Hij/zij                 Hij
```
So you can write a sentence as follows:
```
Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}} en
{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad.
{{Hij_zij_student}} al wel.
```
and expect output like so:
```
Heeft je S-team captain al haar vragenlijsten ingevuld voor Rik en zijn vrienden?
Of heeft zij daar nog geen tijd voor gehad. Hij al wel.
```

Please never use `de {{begeleider}}` or `het {{begeleider}}`, but always `je {{begeleider}}` or `jouw {{begeleider}}`.


## Questionnaire Syntax
The `content` attribute of a `Questionnaire` is a serialized array that stores the questionnaire definition. The following types of questions are supported: `:checkbox`, `:radio`, `:range`, `:raw`, `:textarea`.


For all questions, it is allowed to use HTML tags in the texts. Also, you may use any of the special variables defined in the previous section.

### Type: Checkbox
Required options (minimal example):

```
{
  id: :v1,
  type: :checkbox,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']',
}
```

Additionally allowed options (maximal example):
```
{
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v1,
  type: :checkbox,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
   { title: 'Inzicht krijgen in de belevingswereld', shows_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
   { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  otherwise_label: 'Nee, omdat:',
  section_end: true
}
```

The options array can contain either hashes or strings. If it is just a string, it is used as the `title` element.

### Type: Radio
Required options (minimal example):

```
{
  id: :v1,
  type: :radio,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']',
}
```

Additionally allowed options (maximal example):
```
{
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v1,
  type: :radio,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
   { title: 'Inzicht krijgen in de belevingswereld', shows_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
   { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  otherwise_label: 'Nee, omdat:',
  section_end: true
}
```

The options array can contain either hashes or strings. If it is just a string, it is used as the `title` element.

### Type: Range
Required options (minimal example):

```
{
  id: :v1,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
}
```

Additionally allowed options (maximal example):
```
{
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v1,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
  section_end: true
}
```

### Type: Raw
**Raw questionnaire types should not have an id!**
Required options (minimal example):

```
{
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}
```

Additionally allowed options (maximal example):
```
{
  section_start: 'De hoofddoelen',
  hidden: true,
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>',
  section_end: true
}
```

### Type: Textarea
Required options (minimal example):

```
{
  id: :v1,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
}
```

Additionally allowed options (maximal example):
```
{
  section_start: 'Tot slot',
  hidden: true,
  id: :v1,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  section_end: true
}
```


[circleci-image]: https://circleci.com/gh/compsy/vsv.svg?style=svg&circle-token=482ba30c54a4a181d02f22c3342112d11d6e0e8a
[circleci-url]: https://circleci.com/gh/compsy/vsv

[coveralls-image]: https://coveralls.io/repos/github/compsy/vsv/badge.svg?t=MBvZL7&branch=master&service=github
[coveralls-url]: https://coveralls.io/github/compsy/vsv?branch=master

[gemnasium-image]: https://gemnasium.com/badges/cf0e4e7a3f11b8f173805a9270972554.svg
[gemnasium-url]: https://gemnasium.com/github.com/compsy/vsv
