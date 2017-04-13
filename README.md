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
```

## Questionnaires
The `content` attribute of a `Questionnaire` is a serialized array that stores the questionnaire definition. Currently, three types of questions are accepted, with the following attributes:

```ruby
questionnaire.content = [{
               id: :v1,
               type: :radio,
               title: 'Hoe voelt u zich vandaag?',
               options: %w[slecht goed]
             }, {
               id: :v2,
               type: :checkbox,
               title: 'Wat heeft u vandaag gegeten?',
               options: ['brood', 'kaas en ham', 'pizza']
             }, {
               id: :v3,
               type: :range,
               title: 'Hoe gaat het met u?',
               labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens']
             }]
```

[circleci-image]: https://circleci.com/gh/compsy/vsv.svg?style=svg&circle-token=482ba30c54a4a181d02f22c3342112d11d6e0e8a
[circleci-url]: https://circleci.com/gh/compsy/vsv

[coveralls-image]: https://coveralls.io/repos/github/compsy/vsv/badge.svg?t=MBvZL7&branch=master&service=github
[coveralls-url]: https://coveralls.io/github/compsy/vsv?branch=master

[gemnasium-image]: https://gemnasium.com/badges/cf0e4e7a3f11b8f173805a9270972554.svg
[gemnasium-url]: https://gemnasium.com/github.com/compsy/vsv
