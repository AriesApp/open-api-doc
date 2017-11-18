# WaiverForever OpenAPI Specification
[![Build Status](https://travis-ci.org/AriesApp/open-api-doc.svg?branch=master)](https://travis-ci.org/AriesApp/open-api-doc)

## Introduction

WaiverForever is a leading edge electronic waiver system, streamline your business is our first priorities. so we take it seriously to steadily openning our APIs for third party developers and power users.

By integrating our APIs with existing services or creating them from scratch, users should be able to improve or automate new workflows which couldn't done before.

For demonstration, we have built a [Zapier](https://zapier.com) app based upon the same APIs. And this is only the first step, please stay stuned for more updates.

### Terminologies

Let's explain some frequently-used terms on WaiverForever.

**Template** is similar to *class* in object-oriented languages, just like a blank form. Each template in WaiverForever has a unique identifier and multiple versions. Each time after you edit and save, a new template version will be created. In general, we always return the latest version.

**Wavier** is similar to *instance* in object-oriented languages, just like a filled form. Each time after user sign and submit / upload, a new waiver will be created and saved.

## Workflow

How does it work really?

### 1. Authentication

Firstly, you need a valid **api key** to access our APIs, each API key should represent one standalone app. You can generate and revoke your API keys in the  [Settings / API]() tab.

The authentication mechanism is quite simple, all your need to do is adding a customer HTTP header: `X-API-Key`

```
GET /auth/ping \
    -H X-API-Key: <api_key>
```

### 2. Webhooks

Secondly, we leverage webhooks to notify you.

Webhooks are commonly used techniques that allow you to build or set up apps which subscribe to certain events on WaiverForever.

For example, when a new waiver is signed, aka a `new_waiver_signed` event is triggered, we'll send a HTTP POST payload with the waiver data to the webhook's target URL.

Please note that webhooks work on template / waiver level.

We'll support more events in the feature.

#### Dynamic

Dynamic webhooks provide maximum flexibility to manage your events, you can subscribe / unsubscribe them at anytime.

The whole flow is dead simple:

```
Your App				       WavierForever			              User                                          
|                                   |                                   |
|---------------------------------->|                                   
|1) Auth ping (optional)            |                                   |
|                                   |                                   
|<----------------------------------|                                   |
|2) Return success if API key valid |                                   
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

#### Static

Comparing to dynamic webhooks, static webhooks are relative easy to setup (you don't have to write code). Just go to the template settings page, paste your target URL, then we'll handle the reset for you.

Under the hood, static webhooks are also built on top of the dynamic webhooks.

You can find the comprehensive documentation [here](https://ariesapp.github.io/open-api-doc/)
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
2. Checkout console output to see where local server is started. You can use all [links](#links) (except `preview`) by replacing https://ariesapp.github.io/open-api-doc/ with url from the message: `Server started <url>`
3. Make changes using your favorite editor or `swagger-editor` (look for URL in console output)
4. All changes are immediately propagated to your local server, moreover all documentation pages will be automagically refreshed in a browser after each change
**TIP:** you can open `swagger-editor`, documentation and `swagger-ui` in parallel
5. Once you finish with the changes you can run tests using: `yarn test`
