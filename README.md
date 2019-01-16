# VSV
Ruby Application for the Vroegtijdig School Verlaten Dagboekonderzoek

[![Circle CI][circleci-image]][circleci-url]
[![Coverage Status][coveralls-image]][coveralls-url]
[![Dependabot Status][dependabot-image]](dependabot-url)

## Reference
Emerencia, A.C., Blaauw, F.J., Snell, N.R., Blijlevens, T., Kunnen, E.S., De Jonge, P. & Van der Gaag, M.A.E. (2017). U-can-act Web-app (Version 1.0) [Web application software]. Retrieved from [www.u-can-act.nl](www.u-can-act.nl)

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
- Redis
- Yarn (on macOS: `brew install yarn`)

## Configuration
The .env.local file is used for storing all ENV variables. Below is a list of all required ENV variables.

### General settings
```
  SECRET_KEY_BASE: <base used for the tokens>
  HOST_URL: <the url where the application is hosted (e.g. http://myapp.io)>
  HOST_DOMAIN: <just the domain part of HOST_URL (e.g. myapp.io)>
  INFO_EMAIL: <email address to use as sender for user account emails>
  FEEDBACK_EMAIL: <email address used by the feedback button>
  PROJECT_NAME: <name of the project (e.g. Vsv)>

  MESSAGEBIRD_ACCESS_KEY: <access key for messagebird>
  MESSAGEBIRD_SEND_FROM: <sender name shown for SMS>

  PERSON_SALT: <salt used to hash person ids in the exporter>
  STOP_SUBSCRIPTION_SALT: <salt used for hashing the stop_subscription keys>

  ADMIN_USERNAME: <user name for the admin panel>
  ADMIN_PASSWORD: <password for the admin panel>

  MAILGUN_API_KEY: <the API key retrieved from mailgun, starts with key->
  MAILGUN_DOMAIN: <the domain configured with mailgun to send mail from, e.g., sandbox43bf51fb258844f0bc393e806ebd25bb.mailgun.org or mg.u-can-act.nl>
  FROM_EMAIL_ADDRESS: <the email address to send the email from, e.g., info@u-can-act.nl>

  AUTH0_CLIENT_ID: <the client id of the client used at auth0>
  AUTH0_DOMAIN: <the auth0 domain, e.g., ucanact.eu.auth0.com>
  AUTH0_CLIENT_SECRET: <the client secret from auth0
  AUTH0_REDIRECT_URL: <the url to do the callback to. Should be something like: http://vsv.io/admin/callback>
  AUTH0_AUDIENCE: <The auth0 audience>
  AUTH0_SIGNING_CERTIFICATE: <the BASE64 encoded certificate>

  REDIS_HOST: <the url of the redis host>
  REDIS_PORT: <the port of the redis host>
  REDIS_PASSWORD: <the password of the redis host>

  TEST_PHONE_NUMBERS: <the list of phonenumbers that are actually test phone numbers. The list needs to be comma separated, eg 0612341234,0676565641>
  SNITCH_KEY: <the key which the snitcher should call>

  API_KEY: <the secret username that can be used to access the api>
  API_SECRET: <the secret password that can be used to access the api>

  IP_HASH_SALT: <for certain users we store the hashed ip address. The hash is generated with this salt>
```

### Organization-specific settings
Organization specific settings can be found in `config/settings.yml`. One of the variables defined here is `application_name`, which is used in determining the directory for organization specific configuration files such as locales (e.g., files in the directory `config/organization/my_organization/` are used if `application_name` is `my_organization`).

The file structure of the `my_organization` directory should be as follows:

```
|
|- settings.yml
|- locales/
|- asssets/
```
Support for organization-specific `settings.yml` and `assets/` will be added soon.

In `settings.yml`, the following settings are required:
```yaml
application_name:   <Name of the application>
default_team_name:  <Name of the default team>
project_start_date: <Date that the project started in the format yyyy-mm-dd, e.g., '2017-10-01'>
project_end_date:   <Date that the project ended in the format yyyy-mm-dd, e.g., '2018-08-06'>
logo:
  mentor_logo: <Filename of the mentor logo, e.g., 'mentor_logo.png'>
  student_logo: <Filename of the student logo, e.g., 'student_logo.png'>
  fallback_logo: <Default logo when there is no student or mentor, e.g., 'logo.png'>
  company_logo: <OPTIONAL. Filename of a company logo. If missing, the header uses only one logo>
```
The settings in `settings.yml` should be sectioned under `development`, `production`, `test`, and `staging`. See the relevant files in this repository for examples.

### Development configuration
In order to run the Capybara specs of the VSV project, you need to install the chrome headless browser. In MacOS you can do this using Homebrew:
```
  brew install chromedriver
```

## Background jobs
The workings of the app rely on the following background jobs:

Daily (e.g., at 2:30am), the following rake task should run:
```
rake scheduler:complete_protocol_subscriptions
```

Daily (e.g., at 3am), the following rake task should run:
```
rake scheduler:cleanup_invitation_tokens
```

Every 10 minutes, the following rake task should run:
```
rake scheduler:send_invitations
```

Every hour, the following rake task should run:
```
rake scheduler:cache_overview
```

Daily (e.g., at 3pm), the following rake task should run:
```
rake scheduler:monitoring
```

Daily (e.g., at 3:30am), the following rake task should run:
```
rake scheduler:rescheduling
```

Daily (e.g., at 4am), the following rake task should run:
```
rake scheduler:generate_questionnaire_headers
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

| type | team_name | role_title | first_name | last_name | gender | mobile_phone | email | protocol_name | start_date | filling_out_for | filling_out_for_protocol | | end_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Mentor`
 - `team_name`: the name of the team the mentor belongs to
 - `role_title`: the role the mentor has in the team ('mentor', 'maatje', or 'S-teamer')
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `email`: the email address of the mentor
 - `protocol_name`: the name of the protocol the person will participate in (for mentors this is `mentoren voormeting/nameting`
 - `start_date`: the date at which the person should start
 - `filling_out_for`: the phone number for which the mentor is filling out the questionnaire
 - `filling_out_for_protocol`: the protocol the person is filling out for (this is `mentoren dagboek` for mentors)
 - `end_date`: the end date of the protocol subscription

### The Student CSV
For the Student data this should be:

|type | team_name | first_name | last_name | gender | mobile_phone | protocol_name | start_date | end_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Student`
 - `team_name`: the name of the team the student belongs to
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `protocol_name`: the name of the protocol the person will participate in (for students this is `studenten`)
 - `start_date`: the date at which the person should start
 - `end_date`: the end date of the protocol subscription


## Variables that can be used in texts (case-sensitive!):

```
        VARIABLE                    DEFAULT VALUE               EXAMPLE
        ========================================================================
        begeleider                  begeleider                  s-team captain
        Begeleider                  Begeleider                  S-team captain
        zijn_haar_begeleider        zijn/haar                   haar
        Zijn_haar_begeleider        Zijn/haar                   Haar
        hij_zij_begeleider          hij/zij                     zij
        Hij_zij_begeleider          Hij/zij                     Zij
        hem_haar_begeleider         hem/haar                    haar
        Hem_haar_begeleider         Hem/haar                    Haar
        naam_begeleider             je begeleider               Elsa
        Naam_begeleider             Je begeleider               Elsa
        achternaam_begeleider                                   Groen
        Achternaam_begeleider                                   Groen

        je_begeleidingsinitiatief   je begeleidingsinitiatief   De Hondsrug
        Je_begeleidingsinitiatief   Je begeleidingsinitiatief   De Hondsrug

        deze_student                deze student                Rik
        Deze_student                Deze student                Rik
        achternaam_student                                      De Vries
        Achternaam_student                                      De Vries
        zijn_haar_student           zijn/haar                   zijn
        Zijn_haar_student           Zijn/haar                   Zijn
        hij_zij_student             hij/zij                     hij
        Hij_zij_student             Hij/zij                     Hij
        hem_haar_student            hem/haar                    hem
        Hem_haar_student            Hem/haar                    Hem

        datum                       <vandaag>                   01-11-2018
        datum_lang                  <vandaag>                    1 november 2018
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
The `content` attribute of a `Questionnaire` is a serialized array that stores the questionnaire definition. The following types of questions are supported: `:checkbox`, `:radio`, `:range`, `:raw`, `:textarea`, `:textfield`, `:expandable`, `:time`, `:date`, `:dropdown`.


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
  required: true,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  tooltip: 'some tooltip',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3] },
   { title: 'Inzicht krijgen in de belevingswereld', tooltip: 'de belevingswereld van de student', hides_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9], stop_subscription: true },
   { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  show_otherwise: true,
  otherwise_label: 'Nee, omdat:',
  otherwise_tooltip: 'some tooltip',
  show_after: Time.new(2018, 5, 6).in_time_zone,
  section_end: true
}]
```

The options array can contain either hashes or strings. If it is just a string, it is used as the `title` element. The `show_otherwise` field is optional, and determines whether or not the question should have an 'otherwise' field. The `tooltip` field is also optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

In the options array, the `stop_subscription: true` property indicates that the protocol subscription should be canceled when this option is selected.

Note that this (and all other question types) may have a `show_after` property. This may have the following values:

```ruby
# To indicate that a question should appear 4 weeks after the start
# of the protocol subscription, use:
{ show_after: 4.weeks }

# or alternatively, you may specify an absoute date:
{ show_after: Time.new(2018, 6, 5, 9, 0, 0).in_time_zone }
```

Note that the `shows_questions` and `hides_questions` option properties require the corresponding questions to have the `hidden: true` and `hidden: false` properties, respectively. For example:

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
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9], stop_subscription: true },
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

Note that the `shows_questions`, `hides_questions`, and `stop_subscription` option properties here work identically to those described above in the Type: Checkbox section.

Radios are always required.

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
  min: 0,
  max: 100,
  step: 1,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  tooltip: 'some tooltip',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
  section_end: true
}]
```
The range type supports the optional properties `min` and `max`, which are set to 0 and 100 by default, respectively. It also supports `step`, which sets the step size of the slider (set to 1 by default, can also be a fraction).

### Type: Raw
**Raw questionnaire types should not have an id!**
Required and allowed options (minimal example and maximal example):

```ruby
[{
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  section_start: 'De hoofddoelen',
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
  default_value: 'Niks',
  pattern: '[a-z]{1,10}',
  hint: 'Must be a lowercase word between 1 and 10 characters in length',
  placeholder: 'Place holder',
  section_end: true
}]
```

The `tooltip' field is optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

The property `pattern` is a regex that limits what the user can enter. The `hint` property is the error message shown to the user when the input does not satisfy the pattern.

Textfields also support a `default_value` property, which is a default value used to fill out the text field. This can contain a variable, e.g., `default_value: '{{deze_student}}'`.

### Type: Number
Type for integer(?) numbers. Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :number,
  title: 'Wat is je postcode?'
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :number,
  title: 'Wat is je postcode?',
  tooltip: 'some tooltip',
  maxlength: 4,
  placeholder: '1234',
  min: 0,
  max: 9999,
  required: true,
  section_end: true
}]
```

Properties specific to `number` are `min` and `max`, for numerical limits, and `maxlength`, which can be used to restrict long numerical inputs (should probably be used in conjunction with pattern if the exact format of the number is known).

The `required` property is also supported. The default is that numbers are not required.

The `number` type does not support `pattern` or `hint` because these properties are not supported by the html 5 `number` input type.

Also, the `placeholder` property is supported for numbers.

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

### Type: Time
Required and allowed options (minimal example):

```ruby
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

### Type: Date
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :date,
  title: 'Wanneer ben je gestopt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :date,
  today: true,
  title: 'Wanneer ben je gestopt?',
  required: true,
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  min: [2018, 06, 14],
  max: [2018, 07, 20],
  section_end: true
}]
```

The `min` and `max` properties can be either two arrays as in the above example, or they can be of the following form: `min: -15, max: true` meaning that the max is today, and the minimum date is 15 days ago (max can also be set to false, which removes any limits).

Please note that there is currently a bug in the date picker when you specify dates as arrays. So if you want june 14th, as a start date, use [2018, 5, 14], i.e., subtract one from the month.

If the `today` property is present, then the default value for the date is set to today. (e.g., `today: true`)

### Type: Unsubscribe
Including an unsubscribe question type will display a card that allows the user to unsubscribe from the protocol. Typically, you want only one `unsubscribe` question in your questionnaire, as the first item in the questionnaire. You may want to control its visibility by specifying a `show_after` property.

Including an unsubscribe type "question" in a questionnaire will show a card with a button. Clicking this button will redirect the user to the unsubscribe route for the protocol subscription to which the current questionnaire belongs. If the protocol has a stop measurement, the user is first redirected to fill out this questionnaire, after which they will be unsubscribed from the protocol.

Required and allowed options (minimal example):

```ruby
[{
  type: :unsubscribe,
  title: 'Klaar met dit schooljaar?',
  content: 'Ben je klaar met dit schooljaar? Klik dan op de knop \'Onderzoek afronden\' om het onderzoek te voltooien.',
  button_text: 'Onderzoek afronden',
  show_after: Time.new(2018, 6, 15).in_time_zone
}]
```

Unsubscribe questions do not need an `id`.

Usable properties for an unsubscribe `question` type are `title`, `content`, `button_text`, and `data_method` (all are optional).

The default `data_method` is `delete`. The `data_method` should typically not be specified as it should correspond with the `unsubscribe_url` that is supplied by the system when calling the questionnaire generator. Only when we call this private function with `send` to show a card on the mentor dashboard is when we override both the `unsubscribe_url` and the `data_method` but it's a bit of a hack.



### Type: Dropdown
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :dropdown,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :dropdown,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  label: 'RMC regio',
  tooltip: 'some tooltip',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis'],
  section_end: true
}]
```

The options array must contain of strings. Currently, there is no support for `shows_questions` or `hides_questions` triggers based on selected options in a dropdown.

The dropdown does not support a `show_otherwise` option.

Dropdowns are always required.

A dropdown can have a `placeholder` property which is the text used when no option is selected. If no `placeholder` is specified, a default text is used.

A dropdown can have a `label` property which is a small text that is always visible and is printed directly above the dropdown.

 The `tooltip' field is optional. When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Note that the `shows_questions`, `hides_questions`, and `stop_subscription` option properties here work identically to those described above in the Type: Checkbox section.

[circleci-image]: https://circleci.com/gh/compsy/vsv.svg?style=svg&circle-token=482ba30c54a4a181d02f22c3342112d11d6e0e8a
[circleci-url]: https://circleci.com/gh/compsy/vsv

[coveralls-image]: https://coveralls.io/repos/github/compsy/vsv/badge.svg?branch=master
[coveralls-url]: https://coveralls.io/github/compsy/vsv?branch=master

[dependabot-image]: https://api.dependabot.com/badges/status?host=github&repo=compsy/vsv
[dependabot-url]: https://dependabot.com
