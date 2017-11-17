# WaiverForever OpenAPI Specification
[![Build Status](https://travis-ci.org/AriesApp/open-api-doc.svg?branch=master)](https://travis-ci.org/AriesApp/open-api-doc)

## Introduction

WaiverForever is a leading edge electronic waiver system, we take it seriously to consider openning our APIs for developers and power users.

By integrating these APIs with existing services or creating them from scratch, users now are able to automate new workflows that couldn't done before.

For demonstration, we have built a [Zapier](https://zapier.com) app using these APIs.

This is only the first step, stay stuned for more open APIs.

### Terminologies

**Template** is similar to *class* in object-oriented languages. Each template in WaiverForever has a unique identifier. Each time after you edit and save it, a new version of this template will be created.

In general, we always return the latest version.

**Wavier** is similar to *instance* in object-oriented languages. Each time after user sign and submit (uploaded), a new waiver was created and saved.

## Workflow

<How it works>

### 1. Authentication

You need a valid **api key** to access these APIs, each API key should represent an standalone app. You can generate and revoke your API keys in the  [Settings / API]() tab.

The auth mechanism is simple, all you need to do is add a customer HTTP header: `X-API-Key`

### 2. Webhooks

Webhooks allow you to build or set up apps which subscribe to certain events on WaiverForever. Webhooks work on template / waiver level.

For example, when a new waiver is signed, aka a `new_waiver_signed` event is triggered, we'll send a HTTP POST payload with the waiver data to the webhook's target URL.

We'll support various events in the feature.

#### Static Webhooks

#### Rest Webhooks

<flow chart>

## Links

- Documentation(ReDoc): https://ariesapp.github.io/open-api-doc/
- SwaggerUI: https://ariesapp.github.io/open-api-doc/swagger-ui/
- Look full spec:
    + JSON https://ariesapp.github.io/open-api-doc/swagger.json
    + YAML https://ariesapp.github.io/open-api-doc/swagger.yaml
- Preview spec version for branch `[branch]`: https://ariesapp.github.io/open-api-doc/preview/[branch]

**Warning:** All above links are updated only after Travis CI finishes deployment

## Working on specification
### Install

1. Install [Node JS](https://nodejs.org/)
2. Clone repo and `cd`
    + Run `npm install`

### Usage

1. Run `npm start`
2. Checkout console output to see where local server is started. You can use all [links](#links) (except `preview`) by replacing https://ariesapp.github.io/open-api-doc/ with url from the message: `Server started <url>`
3. Make changes using your favorite editor or `swagger-editor` (look for URL in console output)
4. All changes are immediately propagated to your local server, moreover all documentation pages will be automagically refreshed in a browser after each change
**TIP:** you can open `swagger-editor`, documentation and `swagger-ui` in parallel
5. Once you finish with the changes you can run tests using: `npm test`
6. Share you changes with the rest of the world by pushing to GitHub :smile:
