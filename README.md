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
  HOST_URL: <the url where the application is hosted (e.g. http://myapp.io)>
  HOST_DOMAIN: <just the domain part of HOST_URL (e.g. myapp.io)>
  INFO_EMAIL: <email address to use as sender for user account emails>
  PROJECT_NAME: <name of the project (e.g. Vsv)>

  MESSAGEBIRD_ACCESS_KEY: <access key for messagebird>
  MESSAGEBIRD_SEND_FROM: <sender name shown for SMS>

  PERSON_SALT: <salt used to hash person ids in the exporter>

  ADMIN_USERNAME: <user name for the admin panel>
  ADMIN_PASSWORD: <password for the admin panel>
```

### Development configuration
In order to run the Capybara specs of the VSV project, you need to install the chrome headless browser. In OSX you can do this using Homebrew:
```
  brew install chromedriver
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

## Creating Protocols and Measurements
There are two types of Measurements. Periodical and one-time measurements. Periodical measurements are measurements that have a `period` that is not nil. Periodical measurements are repeated each `period` from `protocol_subscription.start_date + measurement.open_from_offset` until `protocol_subscription.end_date - measurement.offset_until_end`. The `protocol_subscription.end_date` can be specified when creating a protocol subscription, or if it is not specified, it is initialized with a default value of `protocol_subscription.start_date + protocol.duration`.

For non-periodical measurements, the `offset_until_end` is ignored.

## Importing new students and mentors
New mentors and students can be imported using the `echo_people` use case. 

```ruby
  be rake "maintenance:echo_people[CSV_NAME]"
```

in which `CSV_NAME` should be replaced with the file name of the CSV containing the mentor / student data. It is important that the format of the CSV is ordered as follows. 

### The Mentor CSV)
For the Mentor data this should be:

| type | organization_name | role_title | first_name | last_name | gender | mobile_phone | email | protocol_name | start_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Mentor`
 - `organization_name`: the name of the organization the mentor belongs to
 - `role_title`: the role the mentor has in the organization ('mentor', 'maatje', or 'S-teamer')
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `email`: the email address of the mentor
 - `protocol_name`: the name of the protocol the person will participate in (for mentors this is `mentoren voormeting/nameting`
 - `start_date`: the date at which the person should start
 - `filling_out_for`: the phone number for which the mentor is filling out the questionnaire
 - `filling_out_for_protocol`: the protocol the person is filling out for (this is `mentoren dagboek` for mentors)

### The Student CSV
For the Student data this should be:

|type | organization_name | first_name | last_name | gender | mobile_phone | protocol_name | start_date|
| --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Student`
 - `organization_name`: the name of the organization the student belongs to
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `protocol_name`: the name of the protocol the person will participate in (for students this is `studenten`)
 - `start_date`: the date at which the person should start



## Variables that can be used in texts:

```
        VARIABLE                    DEFAULT VALUE           EXAMPLE
        =======================================================================
        begeleider                  begeleider              s-team captain
        Begeleider                  Begeleider              S-team captain
        zijn_haar_begeleider        zijn/haar               haar
        Zijn_haar_begeleider        Zijn/haar               Haar
        hij_zij_begeleider          hij/zij                 zij
        Hij_zij_begeleider          Hij/zij                 Zij
        hem_haar_begeleider         hem/haar                haar
        Hem_haar_begeleider         Hem/haar                Haar
        deze_student                deze student            Rik
        Deze_student                Deze student            Rik
        zijn_haar_student           zijn/haar               zijn
        Zijn_haar_student           Zijn/haar               Zijn
        hij_zij_student             hij/zij                 hij
        Hij_zij_student             Hij/zij                 Hij
        hem_haar_student            hem/haar                hem
        Hem_haar_student            Hem/haar                Hem
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
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :checkbox,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :checkbox,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  tooltip: 'some tooltip',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
   { title: 'Inzicht krijgen in de belevingswereld', tooltip: 'de belevingswereld van de student', hides_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
   { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  show_otherwise: true,
  otherwise_label: 'Nee, omdat:',
  otherwise_tooltip: 'some tooltip',
  section_end: true
}]
```

The options array can contain either hashes or strings. If it is just a string, it is used as the `title` element. The `show_otherwise` field is optional, and determines whether or not the question should have an 'otherwise' field. The `tooltip' field is also optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Note that the `shows_questions` and `hides_questions` fields require the corresponding questions to have the `hidden: true` and `hidden: false` properties, respectively. For example:

```ruby
[{
  id: :v1,
  type: :checkbox,
  title: 'Vraag?',
  options: [{title: 'antwoord', hides_questions: %i[v2], shows_questions: %i[v3]}]
},{
  id: :v2,
  hidden: false,
  type: '...'
},{
  id: :v3,
  hidden: true,
  type: '...'
}]
```

### Type: Radio
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :radio,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :radio,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  tooltip: 'some tooltip',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
   { title: 'Inzicht krijgen in de belevingswereld', hides_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9] },
   { title: 'Vaardigheden ontwikkelen', tooltip: 'Zoals wiskunde', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  show_otherwise: true,
  otherwise_label: 'Nee, omdat:',
  otherwise_tooltip: 'some tooltip',
  section_end: true
}]
```

The options array can contain either hashes or strings. If it is just a string, it is used as the `title` element.  The `show_otherwise` field is optional, and determines whether or not the question should have an 'otherwise' field. The `tooltip' field is also optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Note that the `shows_questions` and `hides_questions` fields here work identically to those described above in the Type: Checkbox section.

### Type: Range
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  tooltip: 'some tooltip',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
  section_end: true
}]
```

### Type: Raw
**Raw questionnaire types should not have an id!**
Required and allowed options (minimal example and maximal example):

```ruby
[{
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>',
  section_end: true
}]
```

### Type: Textarea
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  section_end: true
}]
```

The `tooltip' field is optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

### Type: Textfield
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :textfield,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :textfield,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  section_end: true
}]
```

The `tooltip' field is optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

### Type: Expandable
Expandable questionnaire questions are essentially mini questionnaires within each questionnaire. They can introduce `max_expansions` new sub-questionnaires within the question (if not specified, this is 10). Furthermore, one can specify a number of `default_expansions`, which is the number of times the sub-questionnaire should be injected in the main questionnaire (if not specified this is 0).

```ruby
[{
  id: :v17,
  title: 'Doelen voor deze student',
  remove_button_label: 'Verwijder doel',
  add_button_label: 'Voeg doel toe',
  type: :expandable,
  default_expansions: 1,
  max_expansions: 10,
  content: [{
    id: :v17_1,
    type: :textarea,
    title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
  }, {
    id: :v17_2,
    type: :checkbox,
    title: 'Wat voor acties hoorden hierbij?',
    options: ['Laagdrempelig contact gelegd',
              'Praktische oefeningen uitgevoerd',
              'Gespreks- interventies/technieken gebruikt',
              'Het netwerk betrokken',
              'Motiverende handelingen uitgevoerd',
              'Observaties gedaan']
  }, {
    id: :v17_3,
    type: :checkbox,
    title: 'Welke hoofddoelen hoorden er bij deze acties?',
    options: [
      'De relatie verbeteren en/of onderhouden',
      'Inzicht krijgen in de belevingswereld',
      'Inzicht krijgen in de omgeving',
      'Zelfinzicht geven',
      'Vaardigheden ontwikkelen',
      'De omgeving vreanderen/afstemmen met de omgeving'
    ]
  },{
    id: :v17_4,
    type: :range,
    title: 'Slider 1 (lorem!)',
    labels: ['zelf geen invloed', 'zelf veel invloed']
  },{
    id: :v17_5,
    type: :range,
    title: 'Slider 2 (lorem!)',
    labels: ['zelf geen invloed', 'zelf veel invloed']
  }]
}]
```
If the `content` of an expandable question contains questions with options that have the `shows_questions` or `hides_questions` attribute, the IDs will be dynamically adjusted so that it works for both static and dynamic IDs. (E.g., if you say `shows_questions: %i[v3_5]`, it will toggle the questions `v3_5` and `v3_<id>_5`, where `<id>` is the index of the current iteration in the expansion). Note that questions can only toggle ids in the same iteration, or normal static questions (outside of the expandable area).

### Type: time
Required and allowed options (minimal example):

```
[{
  id: :v1,
  type: :time,
  hours_from: 0,
  hours_to: 6,
  hours_step: 1,
  title: 'Hoeveel tijd heb je deze week besteed aan de begeleiding van deze student?'
}]
```
The dropdown will start from `hours_from` and will offer options until `hours_to`, with a stepsize of `hour_step`.

[circleci-image]: https://circleci.com/gh/compsy/vsv.svg?style=svg&circle-token=482ba30c54a4a181d02f22c3342112d11d6e0e8a
[circleci-url]: https://circleci.com/gh/compsy/vsv

[coveralls-image]: https://coveralls.io/repos/github/compsy/vsv/badge.svg?t=MBvZL7&branch=master&service=github
[coveralls-url]: https://coveralls.io/github/compsy/vsv?branch=master

[gemnasium-image]: https://gemnasium.com/badges/github.com/compsy/vsv.svg
[gemnasium-url]: https://gemnasium.com/github.com/compsy/vsv
