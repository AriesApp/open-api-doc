# WaiverForever OpenAPI Specification
[![Build Status](https://travis-ci.org/AriesApp/open-api-doc.svg?branch=master)](https://travis-ci.org/AriesApp/open-api-doc)

## Introduction

WaiverForever is a leading edge electronic waiver system. Streamlining your business is our first priority. We take it seriously to steadily openning our APIs for third-party developers and power users.

By integrating our APIs with existing services or creating them from scratch, users are now able to create or improve workflows that's not possible before.

For demonstration, we have built a [Zapier](https://zapier.com) app based on these APIs. This is only the first step, stay tuned for more updates.

### Terminologies

Let's explain some frequently-used terms of WaiverForever.

**Template** is similar to a *class* in object-oriented languages, in other words a blank waiver form. Each template in WaiverForever has a unique identifier and multiple versions. Each time a waiver is edited and saved, a new template version is created. In general, we always return the latest version when requesting a waiver template.

**Wavier** is similar to an *instance* in object-oriented languages, in other words a filled waiver form. Each time after user sign and submit/upload, a new waiver is created and saved.

## Workflow

How does it work really?

### 1. Authentication

First off, you need a valid **API key** to access our APIs, each API key should represent one standalone app. You can generate and revoke your API keys in the  [Settings / API]() tab.

The authentication mechanism is quite simple, all you need to do is to add a custom HTTP header: `X-API-Key`.

like this:

```
GET /auth/ping \
    -H X-API-Key: <api_key>
```

### 2. Webhooks

Second, we use webhooks to communicate with you.

Webhook is a commonly used technique that allows you to build or set up apps which subscribe to certain events on WaiverForever.

For example, when a new waiver is signed, aka a `new_waiver_signed` event is triggered, we'll send an HTTP POST payload with the waiver data to the webhook's target URL.

Please note that webhooks work on the template/waiver level.

We'll support more webhook events in the future.

#### Dynamic Webhooks

Dynamic webhooks provide maximum flexibility to manage your events. You can subscribe/unsubscribe to dynamic webhooks at any time.

The whole flow is dead simple:

```
Your App		       WavierForever		              User                                          
|                                   |                                   |
|---------------------------------->|                                   
|1) Auth ping (optional)            |                                   |
|                                   |                                   
|<----------------------------------|                                   |
|2) Return 200 if API key valid     |                                   
|                                   |                                   |
|---------------------------------->|                                   
|3) Subscribe template event        |                                   |
|e.g. `new_waiver_signed`           |                                   
|                                   |<----------------------------------|
|                                   |4) Sign and upload a waiver        |
|<----------------------------------|                                   |
|5) POST waiver payload             |                                   |
|                                   |                                   |
|---------------------------------->|                                   |
|6) Download waiver pdf             |                                   |
|                                   |                                   |
|---------------------------------->|                                   |
|7) Unsubscribe event               |                                   |
|                                   |                                   |
X                                   |                                   |
X                                   |                                   |
|                                   |                                   |
                                    |                                   |
                                    |                                   |
                                    |                                   |
                                    |                                   |
```

#### Static Webhooks

Compared to dynamic webhooks, static webhooks are relatively easy to setup (you don't have to write code). Just go to the template settings page, specify your target URL, then we'll handle the rest for you.

Under the hood, static webhooks are also built on top of dynamic webhooks.

You can find a comprehensive documentation [here](https://ariesapp.github.io/open-api-doc/).

## Model

A sample **waiver** JSON model:

```js
{
  "waiver_id": "zZ613txA741510127626",
  "has_pdf": true,
  "pictures": [
    {
      "title": "Your Photo",
      "url": "<temp_s3_url>",
      "timestamp": 1510127609
    }
  ],
  "data": [
    {
      "value": "HF",
      "type": "initial_field",
      "title": "please type your initials"
    },
    {
      "first_name": "first",
      "middle_name": "",
      "last_name": "",
      "value": "first m last",
      "title": "Please fill in your name",
      "type": "name_field"
    },
    {
      "title": "Please fill in your email",
      "value": "gh@me.com",
      "type": "email_field"
    },
    {
      "value": "1 851-234-5678",
      "title": "Please fill in your phone number",
      "type": "phone_field"
    },
    {
      "state": "TX",
      "first_line": "No 123",
      "value": "No 123 TX, USA",
      "type": "address_field",
      "country": "USA",
      "title": "Please fill in your address",
      "zipcode": "123456",
      "second_line": "",
      "city": ""
    },
    {
      "value": "18",
      "title": "Please fill in your age",
      "type": "age_field"
    },
    {
      "type": "date_field",
      "title": "Please fill date",
      "value": "2017-11-8",
      "year": "2017",
      "month": "11",
      "day": "8"
    },
    {
      "type": "checkbox_field",
      "title": "Text to agree on",
      "value": "checked"
    },
    {
      "value": "Ghosts ",
      "title": "Your fav team",
      "type": "short_answer_field"
    },
    {
      "value": "Femal",
      "title": "Male or Female",
      "type": "single_choice_field"
    },
    {
      "value": ["Magazine", "Trip advisor"],
      "title": "Where did you hear about us? (Gain market insight!)",
      "type": "multiple_choice_field"
    },
    {
      "type": "container_field",
      "title": "please enter your minors' information",
      "result_list": [
        [
          {
            "first_name": "first",
            "middle_name": "",
            "last_name": "",
            "value": "C1 first m last",
            "title": "Please fill in your name",
            "type": "name_field"
          },
          {
            "title": "Please fill in your email",
            "value": "C1 gh@me.com",
            "type": "email_field"
          }
        ],
        [
          {
            "first_name": "first",
            "middle_name": "",
            "last_name": "",
            "value": "C2 first m last",
            "title": "Please fill in your name",
            "type": "name_field"
          },
          {
            "title": "Please fill in your email",
            "value": "C2 gh@me.com",
            "type": "email_field"
          }
        ]
      ]
    }
  ],
  "received_at": "1510127625",
  "template_version": "2.0",
  "template_title": "Bike Rental Waiver",
  "template_id": "JwIvKHHfW81493594388",
  "signed_at": 1510127615,
  "geolocation": {
      "accuracy": 5,
      "latitude": "137.785834",
      "longitude": "-22.406417"
  }
}
```

## Links

- Documentation: https://ariesapp.github.io/open-api-doc/
- SwaggerUI: https://ariesapp.github.io/open-api-doc/swagger-ui/
- Look full spec:
    + JSON https://ariesapp.github.io/open-api-doc/swagger.json
    + YAML https://ariesapp.github.io/open-api-doc/swagger.yaml

## Working on specification
### Install

1. Install [Node JS](https://nodejs.org/)
2. Clone repo and `cd`
    + Run `yarn install`

### Usage

1. Run `yarn start`
2. Check console output to see where the local server is started. You can use all [links](#links) (except `preview`) by replacing https://ariesapp.github.io/open-api-doc/ with url from the message: `Server started <url>`
3. Make changes using your favorite editor or `swagger-editor` (look for URL in console output)
4. All changes are immediately propagated to your local server. In addition, all documentation pages will be automagically refreshed in a browser after each change
**TIP:** you can open `swagger-editor`, documentation and `swagger-ui` in parallel
5. Once you finish with the changes you can run tests using: `yarn test`
