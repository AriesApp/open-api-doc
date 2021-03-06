---
title: WavierForever Open API v1.0.0
language_tabs:
  - shell: cURL
  - javascript--nodejs: Node.js
  - ruby: Ruby
  - python: Python
toc_footers:
  - >-
    <a href="https://www.waiverforever.com">Find out more about
    WaiverForever</a>
includes: []
search: true
highlight_theme: darkula
headingLevel: 2
---

# WaiverForever OpenAPI

Contact: <a href="mailto:mobile@waiverforever.com">mobile@waiverforever.com</a></br>
License: <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache 2.0</a></br>
<a href="https://www.waiverforever.com/terms">Terms of service</a></br>

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

## Introduction

WaiverForever is a leading edge electronic waiver system. Streamlining your business is our first priority. We take it seriously to steadily openning our APIs for third-party developers and power users.

By integrating our APIs with existing services or creating them from scratch, users are now able to create or improve workflows that's not possible before.

For demonstration, we have built a [Zapier](https://zapier.com) app based on these APIs. This is only the first step, stay tuned for more updates.

### Terminologies

Let's explain some frequently-used terms of WaiverForever.

**Template** is similar to a *class* in object-oriented languages, in other words a blank waiver form. Each template in WaiverForever has a unique identifier and multiple versions. Each time a waiver is edited and saved, a new template version is created. In general, we always return the latest version when requesting a waiver template.

**Waiver** is similar to an *instance* in object-oriented languages, in other words a filled waiver form. Each time after user sign and submit/upload, a new waiver is created and saved. Waiver may have pictures attached.

**Field** is the smallest logical unit of a template or a waiver. You can find all the fields we support here: [Field Types](#schemafield).

## Workflow

How does it work really?

### 1. Authentication

First off, you need a valid **API key** to access our APIs. Each API key should represent one standalone app. You can generate and revoke your API keys in the  [Settings / Integration](https://app.waiverforever.com/settings/integrations) tab.

The authentication mechanism is quite simple, all you need to do is to add a custom HTTP header: `X-API-Key`.

### 2. Webhooks

Second, we use webhooks to communicate with you.

Webhook is a commonly used technique that allows you to build or set up apps which subscribe to certain events on WaiverForever.

For example, when a `new_waiver_signed` event is triggered, aka a new waiver is signed, we'll send an HTTP POST payload with the waiver data to the webhook's target URL.

Please note that webhooks work on the template/waiver level.

We'll support more webhook events in the future.

#### Dynamic Webhooks

Dynamic webhooks provide maximum flexibility to manage your events. You can subscribe/unsubscribe to dynamic webhooks at any time.

#### Static Webhooks

Compared to dynamic webhooks, static webhooks are relatively easy to setup (you don't have to write code). Just go to the template settings page, specify your target URL, then we'll handle the rest for you.

<aside class="notice">
We will implement Static Webhooks in the future.
</aside>

### 3. API

Base URLs:

* <a href="https://api.waiverforever.com">https://api.waiverforever.com</a>

The whole flow is dead simple ->


```
Your App                     WavierForever                             User
|                                   |                                   |
|---------------------------------->|
|1) Auth ping (optional)            |                                   |
|                                   |
|<----------------------------------|                                   |
|2) Return 200 if API key valid     |
|                                   |                                   |
|---------------------------------->|
|3) Subscribe template event        |                                   |
| with your target url.             |
| e.g. `new_waiver_signed`          |                                   |
|                                   |<----------------------------------|
|                                   |4) Sign and upload a waiver        |
|<----------------------------------|                                   |
|5) POST waiver payload to target   |                                   |
| url                               |                                   |
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

# Authentication

WaiverForever uses API keys to allow access to the API. You can register a new API key at [Settings / Integration tab](https://app.waiverforever.com/settings/integrations).

WaiverForever expects for the API key to be included in all API requests to the server in a header that looks like the following:

`X-API-Key: api_key`

<aside class="notice">
You must replace <code>api_key</code> with your personal API key.
</aside>

# Auth Endpoints

## Get User Info

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/auth/userInfo \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/auth/userInfo', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/auth/userInfo', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/auth/userInfo', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/auth/userInfo`

*Get user info for the API key*

> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": {
    "username": "demo@example.com"
  }
}

```
<h3 id="authPing-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[Response](#schemaresponse)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

<h3 id="authPing-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
username|string|true|username of the account

<aside class="success">
Use this API to test your API key.
</aside>

# Webhooks Endpoints

Subscribe / Unsubscribe webhooks events.

Current support events:

Event|Payload Schema|Description
---|---|---|
`new_waiver_signed`|[Waiver](#schemawaiver)|a new waiver is signed

## Subscription Resource

Name|Type|Required|Description
---|---|---|---|
id|string|true|subscription id
event|string|true|event name
template_id|string|true|template id
target_url|string|true|target url

## Get All Subscriptions

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/webhooks/ \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');
const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/webhooks/', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/webhooks/', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/webhooks/', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/webhooks/`

*Get all webhooks subscriptions.*

> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": [{
    "id": "subscription id",
    "event": "event name",
    "template_id": "template id",
    "target_url": "target url"
  }]
}
```
<h3 id="subscribeEvent-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[[Subscription]](#schemasubscription)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

## Subscribe an event

> Code samples

```shell
# You can also use wget
curl -X POST https://api.waiverforever.com/openapi/v1/webhooks/ \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>' \
  -d '{
  "target_url": "",
  "template_id": "",
  "event": "new_waiver_signed"
}'
```

```javascript--nodejs
const fetch = require('node-fetch');
const inputBody = `{
  'target_url': '',
  'template_id': '',
  'event': 'new_waiver_signed'
}`;
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/webhooks/', {
  method: 'POST',
  body: inputBody,
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  })
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

payload = {
  'event' => 'new_waiver_signed',
  'template_id' => '',
  'target_url' => ''
}


result = RestClient.post 'https://api.waiverforever.com/openapi/v1/webhooks/', payload.to_json, headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}
data = {
  'target_url': '',
  'template_id': '',
  'event': 'new_waiver_signed'
}

r = requests.post('https://api.waiverforever.com/openapi/v1/webhooks/', json=data, headers=headers)

print(r.json())

```

`POST /openapi/v1/webhooks/`

*Subscribe an event.*

Subscribe an event you care about, and WaiverForever will call you back when certain it occurred.

> Body parameter

```json
{
  "event": "<event_name>",
  "target_url": "<callback url>",
  "template_id": "<template_id>"
}
```
<h3 id="subscribeEvent-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
body|body|object|false|Event that you're interested.
» event|body|string|true|event name
» target_url|body|string|true|callback url
» template_id|body|string|true|template id

> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": {
    "id": "subscription id",
    "event": "event name",
    "template_id": "template id"
  }
}
```
<h3 id="subscribeEvent-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[Subscription](#schemasubscription)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

## Unsubscribe an event.

> Code samples

```shell
# You can also use wget
curl -X DELETE https://api.waiverforever.com/openapi/v1/webhooks/{subscription_id}/ \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');
const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/webhooks/{subscription_id}/', {
  method: 'DELETE',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.delete 'https://api.waiverforever.com/openapi/v1/webhooks/{subscription_id}/', headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.delete('https://api.waiverforever.com/openapi/v1/webhooks/{subscription_id}/', headers=headers)

print(r.json())

```

`DELETE /openapi/v1/webhooks/{subscription_id}/`

*Unsubscribe an event.*

<h3 id="unsubscribeEvent-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
subscription_id|path|string|true|subscription id

> Example responses

```json
{
  "result": true,
  "msg": "success"
}
```
<h3 id="unsubscribeEvent-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[Response](#schemaresponse)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

# Template Endpoints

Access templates

## Template Resources

Name|Type|Required|Description
---|---|---|---|
id|string|true|template id
title|string|true|template title
disabled|boolean|true|true if disabled by user
created_at|integer|true|created timestamp
updated_at|integer|true|updated timestamp

## Get Template list

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/templates \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/templates', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/templates', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/templates', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/templates`

> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": [
    {
      "title": "Demo Wavier",
      "id": "oBrbmWnp7X1446531274",
      "disabled": false,
      "created_at": 1446531274,
      "updated_at": 1493594388
    }
  ]
}
```
<h3 id="GET-/template-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

<h3 id="GET-/template-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[[Template](#schematemplate)]|true|template list

## Request Waiver

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver?ttl=<ttl> \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver?ttl=<ttl>', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver?ttl=<ttl>', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver?ttl=<ttl>', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/template/{template_id}/requestWaiver?ttl=<ttl>`

*Request a waiver to sign*

<h3 id="requestWaiver-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
template_id|path|string|true|template id
ttl|query|string|false|request waiver expiration time (in seconds), default 86400


> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": {
    "tracking_id": "<tracking_id>",
    "request_waiver_url": "<request_waiver_url>",
    "ttl": 86400
  }
}
```
<h3 id="requestWaiver-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="requestWaiver-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|object|true|data
» tracking_id|string|true|tracking id for requested waiver
» request_waiver_url|string|true|remote signing url for requested waiver
» ttl|string|true|request waiver expiration time (in seconds)

# Waiver Endpoints

Access waiver

## Waiver Resource

Name|Type|Required|Description
---|---|---|---|
id|string|true|waiver id
template_id|string|true|template id
template_title|string|true|template title
has_pdf|boolean|true|true if the PDF is available to download
geolocation|[GeoLocation](#schemageolocation)|false|signing location
received_at|integer|true|server received timestamp, should be 0 if waiver status is not `approved`
signed_at|integer|true|waiver signed timestamp
pictures|[[Picture](#schemapicture)]|false|attached pictures
data|[[Field](#schemafield)]|true|filled fields
device|[Device](#schemadevice)|false|signing device
note|string|true|waiver note
tags|[sting]|true|waiver tags
ip|string|false|ip
status|string|true|waiver status, possible values `pending`, `approved`, `revoked`

## Get Signed Waiver

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/waiver/{waiver_id} \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/waiver/{waiver_id}`

*Get a signed waiver*

<h3 id="getWaiverById-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_id|path|string|true|waiver id


> Example responses

```json
{
  "id": "zZ613txA741510127626",
  "status": "approved",
  "has_pdf": true,
  "pictures": [
    {
      "id": "picture id",
      "title": "Your Photo",
      "timestamp": 1510127609
    }
  ],
  "data": [
    {
      "value": "HF",
      "type": "initial_field",
      "title": "please input your initials"
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
  "template_title": "Bike Rental Waiver",
  "template_id": "JwIvKHHfW81493594388",
  "tracking_id": "D6RkEV1yUK1512568456",
  "received_at": 1510127625,
  "signed_at": 1510127615,
  "note": "",
  "tags": ["tag1", "tag2"],
  "geolocation": {
      "accuracy": 5,
      "latitude": "137.785834",
      "longitude": "-22.406417"
  },
   "device": {
      "device_model": "iPhone 5 (GSM CDMA)(9.3.5)",
      "username": "a",
      "id": "opZTzJP2gI1504892592",
      "device_name": "Jing's iPhone",
      "identifier": ""
  }
}
```
<h3 id="getWaiverById-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="getWaiverById-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[Waiver](#schemawaiver)|true|Signed Waiver

## Get Tracking Waiver

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/waiver/tracking/{tracking_id} \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/waiver/tracking/{tracking_id}', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/waiver/tracking/{tracking_id}', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/waiver/tracking/{tracking_id}', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v1/waiver/tracking_id/{tracking_id}`

*Query signed waiver by tracking id*

<h3 id="queryWaiverByTrackingId-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
tracking_id|path|string|true|tracking id from [requestWaiver](#request-waiver)


> Example responses

```javascript
{
  // same as get signed waiver above
}
```


<h3 id="queryWaiverByTrackingId-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="queryWaiverByTrackingId-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[Waiver](#schemawaiver)|true|Signed Waiver

## Update Waiver Note

> Code samples

```shell
# You can also use wget
curl -X POST https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/note' \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>' \
  -H 'Content-Type': 'application/json' \
  -d '{
    "note":"the note"
  }'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
};

const inputBody = `{
    "note": "the note"
}`;

fetch('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/note', {
  method: 'POST',
  body: inputBody,
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Content-Type' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

payload ={
    "note"=> "the note"
}

result = RestClient.post 'https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/note', payload.to_json, headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
}

data = {
    "note": "the note"
}

r = requests.post('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/note', json=data, headers=headers)

print(r.json())

```

`POST /openapi/v1/waiver/{waiver_id}/note`

*Update waiver note*

<h3 id="updateWaiverNote-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_id|path|string|true|waiver id
note|body|string|true|waiver note

<h3 id="updateWaiverNote-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="updateWaiverNote-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message

## Download Waiver PDF

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf \
  -H 'Accept: */*' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'*/*',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf', {
  method: 'GET',
  headers: headers
}).then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => '*/*',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf', headers

p result
```

```python
import requests
headers = {
  'Accept': '*/*',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf', params={
}, headers=headers)

print r.content

```

`GET /openapi/v1/waiver/{waiver_id}/pdf`

*Download waiver in pdf*

<h3 id="downloadWaiverPdf-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_id|path|string|true|waiver id


> Example responses

<h3 id="downloadWaiverPdf-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|binary
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Wavier not found|None

<aside class="notice">
We will redirect the download request to Amazon S3.
</aside>

## Download Waiver Pictures

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/picture/{picture_id} \
  -H 'Accept: */*' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'*/*'
};

fetch('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/picture/{picture_id}', {
  method: 'GET',
  headers: headers
}).then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => '*/*',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/picture/{picture_id}', headers: headers

p result
```

```python
import requests
headers = {
  'Accept': '*/*',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/picture/{picture_id}', params={
}, headers=headers)

print r.content

```

`GET /waiver/{waiver_id}/picture/{picture_id}`

*Download waiver pictures*

<h3 id="downloadWaiverPdf-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_id|path|string|true|waiver id
picture_id|path|string|true|picture id


> Example responses

<h3 id="downloadWaiverPdf-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|binary
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Wavier not found|None

<aside class="notice">
We will redirect the download request to Amazon S3.
</aside>

## Waiver Search

> Code samples

```shell
# You can also use wget
curl -X POST https://api.waiverforever.com/openapi/v1/waiver/search \
  -H 'Accept: */*' \
  -H 'X-Api-Key: <api_key>'
  -d '{
    "search_term":"query string",
    "start_timestamp": 1400000000,
    "end_timestamp": 1500000000,
    "page": 1,
    "per_page": 10,
    "template_ids": ["kkgVVsMpGx1455624443"]
  }'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

const inputBody = `{
  'search_term': 'query string',
  'start_timestamp': 1400000000,
  'end_timestamp': 1500000000,
  'page': 1,
  'per_page': 10,
  "template_ids": ["kkgVVsMpGx1455624443"]
}`;

fetch('https://api.waiverforever.com/openapi/v1/waiver/search', {
  method: 'POST',
  body: inputBody,
  headers: headers
}).then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => '*/*',
  'Content-Type' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

payload = {
  'search_term' => 'query string',
  'start_timestamp' => 1400000000,
  'end_timestamp' => 1500000000,
  'page' => 1,
  'per_page' => 10,
  "template_ids" => ["kkgVVsMpGx1455624443"]
}

result = RestClient.post 'https://api.waiverforever.com/openapi/v1/waiver/search', payload.to_json, headers

p result
```

```python
import requests
headers = {
  'Accept': '*/*',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
}

data = {
  'search_term': 'query string',
  'start_timestamp': 1400000000,
  'end_timestamp': 1500000000,
  'page': 1,
  'per_page': 10,
  'template_ids': ['kkgVVsMpGx1455624443']
}

r = requests.post('https://api.waiverforever.com/openapi/v1/waiver/search', json=data, headers=headers)

print r.content

```

`POST /openapi/v1/waiver/search`

*search waiver.*

search waiver with keywords.

> Body parameter

```json
{
  "search_term": "<search_term>",
  "start_timestamp": "<start timestamp>",
  "end_timestamp": "<end timestamp>",
  "page": "<page index>",
  "per_page": "<results per page>",
  "template_ids": "<template id list>",
  "note": "<waiver note>",
  "tags": "<tag name list>",
  "device_ids": "<device id list>",
  "group_id": "<group id>"
}
```
<h3 id="waiverSearch-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
body|body|object|true|search conditions.
search_term|body|string|false|search term
start_timestamp|body|int|false|start timestamp in seconds
end_timestamp|body|int|false|end timestamp in seconds
page|body|int|false|page index, default 1
per_page|body|int|false|results per page, default 10
template_ids|body|list[string]|false|templates id list
note|body|string|false|waiver note
tags|body|list[string]|false|tag name list
device_ids|body|list[string]|false|device id list
request_id|body|string|false|waiver request id
> Example responses

```json
{
    "data": {
        "waivers": [
            {
                "signed_at": 1461130513,
                "device": null,
                "template_title": null,
                "template_id": "igcJYpG2KT1381868360",
                "tracking_id": "",
                "has_pdf": true,
                "status": "approved",
                "id": "ChPV4IMuVm1461130523",
                "geolocation": {},
                "pictures": [],
                "note": "",
                "tags": [""],
                "data": [
                    {
                        "city": "",
                        "second_line": "",
                        "country": "",
                        "title": "Please fill in your address",
                        "first_line": "test333",
                        "state": "",
                        "value": "test333",
                        "type": "address_field",
                        "zipcode": ""
                    },
                   ...
                ],
                "received_at": 1461130523
            },
            ...
        ],
        "per_page": 10,
        "page": 1,
        "total": 85
    },
    "result": true,
    "msg": "success"
}
```
<h3 id="waiverSearch-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[Subscription](#schemasubscription)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None


<aside class="notice">
Waiver field `device`, `pictures` and `template_title` is not available in search waiver API.
</aside>

# WaiverRequest Endpoints

Access waiver request

## Waiver Request Resource

Name|Type|Required|Description
---|---|---|---|
id|string|true|request id
name|string|true|request name
size|int|true|request size
note|string|true|request note
type|string|true|request type.  possible values `normal`, `anonymous`
contact_info|string|true|contact info
template_id|string|true|template id of waiver request
status|string|true|request status. possible values `collecting`, `accepted`
request_link|string|true|request share link
datetime|int|true|created timestamp


## Create Waiver Request

> Code samples

```shell
# You can also use wget
curl -X POST https://api.waiverforever.com/openapi/v2/waiverRequest \
  -H 'Accept: application/json' \
  -H 'Content-Type': 'application/json' \
  -H 'X-Api-Key: <api_key>' \
  -d '{
    "name": "waiver request name",
    "size": 1,
    "note": "note",
    "type": "normal",
    "contact_info": "contact info",
    "template_id": "TutFEMdPgR1519947925"
}'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
};

const inputBody = `{
    "name": "waiver request name",
    "size": 1,
    "note": "note",
    "type": "normal",
    "contact_info": "contact info",
    "template_id": "TutFEMdPgR1519947925"
}`;

fetch('https://api.waiverforever.com/openapi/v2/waiverRequest', {
  method: 'POST',
  body: inputBody,
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Content-Type' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

payload ={
    "name"=> "waiver request name",
    "size"=> 1,
    "note"=> "note",
    "type"=> "normal",
    "contact_info"=> "contact info",
    "template_id"=> "TutFEMdPgR1519947925"
}

result = RestClient.post 'https://api.waiverforever.com/openapi/v2/waiverRequest',payload.to_json, headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
}

data = {
    "name": "waiver request name",
    "size": 1,
    "note": "note",
    "type": "normal",
    "contact_info": "contact info",
    "template_id": "TutFEMdPgR1519947925"
}

r = requests.post('https://api.waiverforever.com/openapi/v2/waiverRequest', json=data, headers=headers)

print(r.json())

```

`POST /openapi/v2/waiverRequest`

*Create waiver request*

<h3 id="createWaiverRequest-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
name|body|string|true|request name
size|body|int|true|request size. between 0 and 1000
note|body|string|true|request note
type|body|string|true|request type. possible values `normal`, `anonymous`
contact_info|body|string|true|request contact info
template_id|body|string|true|request template id


> Example responses

```json
{
  "note": "note",
  "accepted_count": 0,
  "size": 1,
  "request_link": "https://app.waiverforever.com/requested_waiver_group/JM2AJFe0Gq1594865417",
  "type": "normal",
  "datetime": 1594865417,
  "name": "waiver request name",
  "contact_info": "contact info",
  "id": "JM2AJFe0Gq1594865417",
  "status": "collecting",
  "template_id": "TutFEMdPgR1519947925"
}
```
<h3 id="createWaiverRequest-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="createWaiverRequest-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[WaiverRequest](#schemawaiverrequest)|true|Waiver Request


## Get Waiver Request

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id} \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v2/waiverRequest/{waiver_request_id}`

*Get a waiver request*

<h3 id="getWaiverRequest-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_request_id|path|string|true|waiver request id


> Example responses

```json
{
  "note": "note",
  "accepted_count": 0,
  "size": 1,
  "request_link": "https://app.waiverforever.com/requested_waiver_group/JM2AJFe0Gq1594865417",
  "type": "normal",
  "datetime": 1594865417,
  "name": "waiver request name",
  "contact_info": "contact info",
  "id": "JM2AJFe0Gq1594865417",
  "status": "collecting",
  "template_id": "TutFEMdPgR1519947925"
}
```
<h3 id="getWaiverRequest-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="getWaiverRequest-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[WaiverRequest](#schemawaiverrequest)|true|Waiver Request

<aside class="notice">
You can use search waiver API to archive waivers in the specific request with parameter `request_id`.
</aside>

## Edit Waiver Request

> Code samples

```shell
# You can also use wget
curl -X POST https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id} \
  -H 'Accept: application/json' \
  -H 'Content-Type': 'application/json' \
  -H 'X-Api-Key: <api_key>' \
  -d '{
    "name": "waiver request name new",
    "size": 2,
    "note": "note new",
    "contact_info": "contact info new",
}'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
};

const inputBody = `{
    "name": "waiver request name new",
    "size": 2,
    "note": "note new",
    "contact_info": "contact info new"
}`;

fetch('https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}', {
  method: 'POST',
  body: inputBody,
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'Content-Type' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

payload ={
    "name"=> "waiver request name new",
    "size"=> 2,
    "note"=> "note new",
    "contact_info"=> "contact info new"
}

result = RestClient.post 'https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}',payload.to_json, headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
  'X-Api-Key': '<api_key>'
}

data = {
    "name": "waiver request name new",
    "size": 2,
    "note": "note new",
    "contact_info": "contact info new"
}

r = requests.post('https://api.waiverforever.com/openapi/v2/waiverRequest/{waiver_request_id}', json=data, headers=headers)

print(r.json())

```

`POST /openapi/v2/waiverRequest/{waiver_request_id}`

*Edit waiver request*

<h3 id="editWaiverRequest-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
waiver_request_id|path|string|true|waiver request id
name|body|string|true|request name
size|body|int|true|request size. between 0 and 1000
note|body|string|true|request note
contact_info|body|string|true|request contact info


> Example responses

```json
{
  "note": "note new",
  "accepted_count": 0,
  "size": 2,
  "request_link": "https://app.waiverforever.com/requested_waiver_group/JM2AJFe0Gq1594865417",
  "type": "normal",
  "datetime": 1594865417,
  "name": "waiver request name new",
  "contact_info": "contact info new",
  "id": "JM2AJFe0Gq1594865417",
  "status": "collecting",
  "template_id": "TutFEMdPgR1519947925"
}
```
<h3 id="editWaiverRequest-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="editWaiverRequest-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[WaiverRequest](#schemawaiverrequest)|true|Waiver Request


## List Waiver Requests

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v2/waiverRequests?template_id=TutFEMdPgR1519947925&name=open&status=collecting&start_timestamp=1593532800&end_timestamp=1595174400&page=1&per_page=5 \
  -H 'Accept: application/json' \
  -H 'X-Api-Key: <api_key>'
```

```javascript--nodejs
const fetch = require('node-fetch');

const headers = {
  'Accept':'application/json',
  'X-Api-Key': '<api_key>'
};

fetch('https://api.waiverforever.com/openapi/v2/waiverRequests?template_id=TutFEMdPgR1519947925&name=open&status=collecting&start_timestamp=1593532800&end_timestamp=1595174400&page=1&per_page=5', {
  method: 'GET',
  headers: headers
}).then(res => res.json())
  .then(body => console.log(body))
  .catch(error => {
    console.log(error);
  });
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-Api-Key' => '<api_key>'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v2/waiverRequests?template_id=TutFEMdPgR1519947925&name=open&status=collecting&start_timestamp=1593532800&end_timestamp=1595174400&page=1&per_page=5', headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-Api-Key': '<api_key>'
}

r = requests.get('https://api.waiverforever.com/openapi/v2/waiverRequests?template_id=TutFEMdPgR1519947925&name=open&status=collecting&start_timestamp=1593532800&end_timestamp=1595174400&page=1&per_page=5', params={
}, headers=headers)

print(r.json())

```

`GET /openapi/v2/waiverRequests`

*List waiver requests*

<h3 id="listWaiverRequest-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
template_id|query|string|true|request template id
name|query|string|false|name search term
status|query|string|false|request status. possible values `collecting`, `accepted`.
start_timestamp|query|int|false|start timestamp in seconds
end_timestamp|query|int|false|end timestamp in seconds
page|query|int|false|page index, default 1
per_page|query|int|false|results per page, default 10


> Example responses

```json
{
  "page": 1,
  "per_page": 5,
  "count": 7,
  "waiver_requests": [
    {
      "id": "B7Z3Z5pymj1594862535",
      "note": "note",
      "size": 10,
      "datetime": 1594862535,
      "template_id": "",
      "request_link": "https://app.waiverforever.com/requested_waiver_group/B7Z3Z5pymj1594862535",
      "contact_info": "c info",
      "type": "normal",
      "status": "collecting",
      "accepted_count": 0,
      "name": "open api created 2"
    },
    ...
  ]
}
```
<h3 id="listWaiverRequest-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None


# Schemas

## Response

<a name="schemaresponse"></a>

```json
{
  "result": true,
  "msg": "success"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
result|boolean|false|request success or fail
msg|string|false|response message

## Subscription

<a name="schemasubscription"></a>

```json
{
  "result": true,
  "msg": "success",
  "data": {
    "id": "subscription id",
    "event": "event name",
    "template_id": "template id",
    "target_url": "target url"
  }
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
id|string|true|subscription id
event|string|true|event name
template_id|string|true|template id
target_url|string|true|target url

## Template

<a name="schematemplate"></a>

```json
{
  "title": "Demo Wavier",
  "id": "oBrbmWnp7X1446531274",
  "disabled": false,
  "created_at": 1446531274,
  "updated_at": 1493594388
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
id|string|true|template id
title|string|true|template title
disabled|boolean|true|true if disabled by user
created_at|integer|true|created timestamp
updated_at|integer|true|updated timestamp


## Waiver

<a name="schemawaiver"></a>

```json
{
  "id": "zZ613txA741510127626",
  "has_pdf": true,
  "pictures": [
    {
      "id": "picture id",
      "title": "Your Photo",
      "timestamp": 1510127609
    }
  ],
  "data": [
    {
      "value": "HF",
      "type": "initial_field",
      "title": "please input your initials"
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
  "template_title": "Bike Rental Waiver",
  "template_id": "JwIvKHHfW81493594388",
  "tracking_id": "D6RkEV1yUK1512568456",
  "received_at": 1510127625,
  "signed_at": 1510127615,
  "geolocation": {
      "accuracy": 5,
      "latitude": "137.785834",
      "longitude": "-22.406417"
  },
   "device": {
      "device_model": "iPhone 5 (GSM CDMA)(9.3.5)",
      "username": "a",
      "id": "opZTzJP2gI1504892592",
      "device_name": "Jing's iPhone",
      "identifier": ""
  },
  "note": "",
  "tags": ["tag1", "tag2"],
  "ip": "1.1.1.1",
  "status": "approved"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
id|string|true|waiver id
template_id|string|true|template id
template_title|string|true|template title
has_pdf|boolean|true|true if the PDF is available to download
geolocation|[GeoLocation](#schemageolocation)|false|signing location
received_at|integer|true|server received timestamp, should be 0 if waiver status is not `approved`
signed_at|integer|true|waiver signed timestamp
pictures|[[Picture](#schemapicture)]|false|attached pictures
tracking_id|string|false|tracking id
data|[[Field](#schemafield)]|false|filled fields
ip|string|false|ip
note|string|true|waiver note
tags|[sting]|true|waiver tags
status|string|true|waiver status, possible values `pending`, `approved`, `revoked`

#### Field Types

<a name="schemafield"></a>

|Property|Value|
|---|---|
» type|name_field|
» type|email_field|
» type|phone_field|
» type|age_field|
» type|initial_field|
» type|date_field|
» type|address_field|
» type|checkbox_field|
» type|short_answer_field|
» type|single_choice_field|
» type|multiple_choice_field|
» type|container_field|

## NameField

<a name="schemanamefield"></a>

```json
{
  "first_name": "first",
  "middle_name": "m",
  "last_name": "last",
  "value": "first m last",
  "title": "Please fill in your name",
  "type": "name_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|name field title
value|string|true|display value
type|string|true|always "name_field"
first_name|string|true|first name
last_name|string|true|last name
middle_name|string|false|middle name (optional)


## EmailField

<a name="schemaemailfield"></a>

```json
{
  "title": "Please fill in your email",
  "value": "demo@example.com",
  "type": "email_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|email field title
value|string|true|filled email
type|string|true|always "email_field"


## PhoneField

<a name="schemaphonefield"></a>

```json
{
  "value": "1 408-123-5678",
  "title": "Please fill in your phone number",
  "type": "phone_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|phone field title
value|string|true|filled phone
type|string|true|always "phone_field"

## InitialField

<a name="schemainitialfield"></a>

```json
{
  "value": "HF",
  "type": "initial_field",
  "title": "please input your initials"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|initial field
value|string|true|initialed value
type|string|true|always "initial_field"

## AgeField

<a name="schemaagefield"></a>

```json
{
  "title": "Please fill in your age",
  "value": "17",
  "type": "age_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|age field title
value|string|true|filled age
type|string|true|always "age_field"


## CheckBoxField

<a name="schemacheckboxfield"></a>

```json
{
  "title": "Text to agree on",
  "value": "checked",
  "checked": true,
  "type": "checkbox_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|checkbox field
value|string|true|checked value
checked|boolean|true|true / false
type|string|true|always "checkbox_field"

## ShortAnswerField

<a name="schemashortanswerfield"></a>

```json
{
  "title": "Your fav team",
  "value": "Mavericks",
  "type": "short_answer_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|short answer field title
value|string|true|filled answer
type|string|true|always "short_answer_field"

## AddressField

<a name="schemaaddressfield"></a>

```json
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
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|address field title
value|string|true|display value
type|string|true|always "address_field"
first_line|string|false|first line
second_line|string|false|second line
city|string|true|city
state|string|true|state or province
country|string|false|country
zipcode|string|true|zipcode or postal code

## DateField

<a name="schemadatefield"></a>

```json
{
  "type": "date_field",
  "title": "Please fill date",
  "value": "2017-11-8",
  "year": "2017",
  "month": "11",
  "day": "8"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|date field
value|string|true|selected date
type|string|true|always "date_field"
year|string|true|year of the date
month|string|true|month of the date
day|string|true|day of the date


## SingleChoiceField

<a name="schemasinglechoicefield"></a>

```json
{
  "value": "Femal",
  "title": "Male or Female",
  "type": "single_choice_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|choice field title
value|string|true|selected choice
type|string|true|always "single_choice_field"

## MultipleChoiceField

<a name="schemamultiplechoicefield"></a>

```json
{
  "value": ["Magazine", "Trip advisor"],
  "title": "Where did you hear about us? (Gain market insight!)",
  "type": "multiple_choice_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|choice field title
value|[string]|true|selected choices
type|string|true|always "multiple_choice_field"

## ContainerField

<a name="schemacontainerfield"></a>

```json
{
  "title": "string",
  "type": "container_field",
  "result_list": [
    // a list of ordinary fields set
  ]
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|container field title
type|string|true|always "container_field"
result_list|[[Field](#schemafield)]|true|a list of ordinary fields set

## Picture

<a name="schemapicture"></a>

```json
{
  "title": "Your Photo",
  "id": "picture id",
  "timestamp": 1510127609
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|picture title
id|string|true|picture id
timestamp|integer|true|created timestamp


## GeoLocation

<a name="schemageolocation"></a>

```json
{
  "accuracy": 5,
  "latitude": "37.785834",
  "longitude": "-122.406417"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
accuracy|integer|true|location accuracy level in meters
latitude|string|true|latitude value
longtitude|string|true|longtitude value


## Device

<a name="schemadevice"></a>

```json
{
    "device_model": "iPhone 5 (GSM CDMA)(9.3.5)",
    "username": "a",
    "id": "opZTzJP2gI1504892592",
    "device_name": "Jing's iPhone",
    "identifier": ""
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
id|string|true|device id
device_name|string|true|device name
device_model|string|true|device model
username|string|false|username
identifier|string|true|device identifier. should always be an empty string

## WaiverRequest

<a name="schemawaiverrequest"></a>

```json
 {
    "id": "B7Z3Z5pymj1594862535",
    "note": "note",
    "size": 10,
    "datetime": 1594862535,
    "template_id": "",
    "request_link": "https://app.waiverforever.com/requested_waiver_group/B7Z3Z5pymj1594862535",
    "contact_info": "c info",
    "type": "normal",
    "status": "collecting",
    "accepted_count": 0,
    "name": "open api created 2"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
id|string|true|request id
name|string|true|request name
size|int|true|request size
note|string|true|request note
type|string|true|request type.  possible values `normal`, `anonymous`
contact_info|string|true|contact info
template_id|string|true|template id of waiver request
status|string|true|request status. possible values `collecting`, `accepted`
request_link|string|true|request share link
datetime|int|true|created timestamp