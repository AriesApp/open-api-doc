---
title: WavierForever Open API v1.0.0
language_tabs:
  - shell: curl
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

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

## Introduction

WaiverForever is a leading edge electronic waiver system. Streamlining your business is our first priority. We take it seriously to steadily openning our APIs for third-party developers and power users.

By integrating our APIs with existing services or creating them from scratch, users are now able to create or improve workflows that's not possible before.

For demonstration, we have built a [Zapier](https://zapier.com) app based on these APIs. This is only the first step, stay tuned for more updates.

### Terminologies

Let's explain some frequently-used terms of WaiverForever.

**Template** is similar to a *class* in object-oriented languages, in other words a blank waiver form. Each template in WaiverForever has a unique identifier and multiple versions. Each time a waiver is edited and saved, a new template version is created. In general, we always return the latest version when requesting a waiver template.

**Wavier** is similar to an *instance* in object-oriented languages, in other words a filled waiver form. Each time after user sign and submit/upload, a new waiver is created and saved. Waiver may have pictures attached.

**Field** is the smallest logical unit of a template or a waiver. You can find all the fields we support here: [Field Types](#schemafield).

## Workflow

How does it work really?

### 1. Authentication

First off, you need a valid **API key** to access our APIs, each API key should represent one standalone app. You can generate and revoke your API keys in the  [Settings / API]() tab.

The authentication mechanism is quite simple, all you need to do is to add a custom HTTP header: `X-API-Key`.

### 2. Webhooks

Second, we use webhooks to communicate with you.

Webhook is a commonly used technique that allows you to build or set up apps which subscribe to certain events on WaiverForever.

For example, when a new waiver is signed, aka a `new_waiver_signed` event is triggered, we'll send an HTTP POST payload with the waiver data to the webhook's target URL.

Please note that webhooks work on the template/waiver level.

We'll support more webhook events in the future.

#### Dynamic Webhooks

Dynamic webhooks provide maximum flexibility to manage your events. You can subscribe/unsubscribe to dynamic webhooks at any time.

The whole flow is dead simple ->

```
Your App                   WavierForever		       User
|                               |                               |
|------------------------------>|
|1) Auth ping (optional)        |                               |
|                               |
|<------------------------------|                               |
|2) Return 200 if API key valid |
|                               |                               |
|------------------------------>|
|3) Subscribe template event    |                               |
|e.g. `new_waiver_signed`       |
|                               |<------------------------------|
|                               |4) Sign and upload a waiver    |
|<------------------------------|                               |
|5) POST waiver payload         |                               |
|                               |                               |
|------------------------------>|                               |
|6) Download waiver pdf         |                               |
|                               |                               |
|------------------------------>|                               |
|7) Unsubscribe event           |                               |
|                               |                               |
X                               |                               |
X                               |                               |
|                               |                               |
                                |                               |
                                |                               |
                                |                               |
                                |                               |
```

#### Static Webhooks

Compared to dynamic webhooks, static webhooks are relatively easy to setup (you don't have to write code). Just go to the template settings page, specify your target URL, then we'll handle the rest for you.

Under the hood, static webhooks are also built on top of dynamic webhooks.

Base URLs:

* <a href="https://api.waiverforever.com/openapi/v1">https://api.waiverforever.com/openapi/v1</a>


<a href="https://www.waiverforever.com/terms">Terms of service</a>
Support Email: <a href="mailto:mobile@waiverforever.com">mobile@waiverforever.com</a>
License: <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache 2.0</a>

# Authentication

WaiverForever uses API keys to allow access to the API. You can register a new API key at [Settings/API tab](https://app.waiverforever.com/settings/api).

WaiverForever expects for the API key to be included in all API requests to the server in a header that looks like the following:

`X-API-Key: api_key`

<aside class="notice">
You must replace <code>api_key</code> with your personal API key.
</aside>

# Auth Endpoints

## Test Auth Ping

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/auth/ping \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');

const headers = {
  'Accept':'application/json'

};

fetch('https://api.waiverforever.com/openapi/v1/auth/ping',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/auth/ping',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/auth/ping', params={

}, headers = headers)

print r.json()
```

`GET /auth/ping`

*Test if the API key is valid*

> Example responses

```json
{
  "result": true,
  "msg": "",
  "data": {
    "username": "string"
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
This API is used for testing.
</aside>

# Webhooks Endpoints

Subscribe / Unsubscribe webhooks events.

Current support events:

- `new_waiver_signed`

## Subscribe an event

> Code samples

```shell
# You can also use wget
curl -X PUT https://api.waiverforever.com/openapi/v1/webhooks \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');
const inputBody = '{
  "event": "new_waiver_signed",
  "target_url": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/webhooks/',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.put 'https://api.waiverforever.com/openapi/v1/webhooks/',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.put('https://api.waiverforever.com/openapi/v1/webhooks/', params={
}, headers = headers)

print r.json()
```

`PUT /webhooks/`

*Subscribe an event.*

Subscribe an event you care about, and WaiverForever will call you back when certain it occurred.

> Body parameter

```json
{
  "event": "new_waiver_signed",
  "target_url": "<callback url>"
}
```
<h3 id="subscribeEvent-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
body|body|object|false|Event that you're interested.
» event|body|string|true|event name
» target_url|body|string|true|callback url

> Example responses

```json
{
  "result": true,
  "msg": "success"
}
```
<h3 id="subscribeEvent-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|[Response](#schemaresponse)
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid API key|None

## Unsubscribe an event.

> Code samples

```shell
# You can also use wget
curl -X DELETE https://api.waiverforever.com/openapi/v1/webhooks/ \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');
const inputBody = '{
  "event": "string",
  "target_url": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/webhooks/',
{
  method: 'DELETE',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.delete 'https://api.waiverforever.com/openapi/v1/webhooks/',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.delete('https://api.waiverforever.com/openapi/v1/webhooks/', params={
}, headers = headers)

print r.json()
```

`DELETE /webhooks/`

*Unsubscribe an event.*

> Body parameter

```json
{
  "event": "<event_name>",
  "target_url": "<callback_url>"
}
```
<h3 id="unsubscribeEvent-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
body|body|object|false|Event that you're not interested any more.
» event|body|string|true|event name
» target_url|body|string|true|callback url


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
title|string|true|template title
id|string|true|template id
disabled|boolean|true|true if disabled by user
created_at|integer|true|created timestamp
update_at|integer|true|updated timestamp

## Get Template list

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/templates \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');

const headers = {
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/templates',
{
  method: 'GET',
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/templates',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/templates', params={
}, headers = headers)

print r.json()
```

*Get template list.*

> Example responses

```json
{
  "result": true,
  "msg": "success",
  "data": [
    {
      "title": "string",
      "id": "string",
      "disabled": true,
      "created_at": 0,
      "update_at": 0
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

## Get Sample Waiver

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/template/{template_id}/sampleWaiver \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');

const headers = {
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/template/{template_id}/sampleWaiver',
{
  method: 'GET',
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/template/{template_id}/sampleWaiver',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/template/{template_id}/sampleWaiver', params={
}, headers = headers)

print r.json()
```

`GET /template/{template_id}/sample`

*Get a sample waiver from specified template id*

<h3 id="getSampleWaiverById-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
template_id|path|string|true|template id


> Example responses

```json
{
  "result": true,
  "msg": "string",
  "data": {
    "waiver_id": "string",
    "template_id": "string",
    "template_version": "string",
    "template_title": "string",
    "has_pdf": true,
    "geolocation": {
      "accuracy": 0,
      "latitude": "string",
      "longtitude": "string"
    },
    "pictures": [
      {
        "title": "string",
        "url": "string",
        "timestamp": 0
      }
    ],
    "received_at": 0,
    "signed_at": 0,
    "data": [
      {
        "title": "string",
        "value": "string",
        "type": "name_field"
      }
    ]
  }
}
```
<h3 id="getSampleWaiverById-responses">Responses</h3>

Status|Meaning|Description|Schema
---|---|---|---|
200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|Successful request|Inline
403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|Invalid api key|None
404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Template not found|None

<h3 id="getSampleWaiverById-responseschema">Response Schema</h3>

Status Code **200**

Name|Type|Required|Description
---|---|---|---|---|
result|boolean|true|request success or fail
msg|string|true|response message
data|[Waiver](#schemawaiver)|true|Tailored Waiver

## Requeset Waiver

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver \
  -H 'Accept: application/json'

```

```javascript--nodejs
const request = require('node-fetch');

const headers = {
  'Accept':'application/json'
};

fetch('https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver',
{
  method: 'GET',
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/template/{template_id}/requestWaiver', params={

}, headers = headers)

print r.json()
```

`POST /template/{template_id}/requestWaiver`

*Request a waiver to sign*

<h3 id="requestWaiver-parameters">Parameters</h3>

Parameter|In|Type|Required|Description
---|---|---|---|---|
template_id|path|string|true|template id


> Example responses

```json
{
  "result": true,
  "msg": "string",
  "data": {
    "tracking_id": "<tracking_id>",
    "tracking_url": "<tracking_url>"
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

# Waiver Endpoints

Access waiver

## Waiver Resource

Name|Type|Required|Description
---|---|---|---|
waiver_id|string|true|waiver id
template_id|string|true|template id
template_version|string|true|template version
template_title|string|true|template title
has_pdf|boolean|true|true if the PDF is available to download
geolocation|[GeoLocation](#schemageolocation)|false|signing location
received_at|integer|true|server received timestamp
signed_at|integer|true|waiver signed timestamp
pictures|[[Picture](#schemapicture)]|false|attached pictures
data|[[Field](#schemafield)]|true|filled fields

You can find a sample JSON [here](./sample_waiver.json).

## Download Waiver PDF

> Code samples

```shell
# You can also use wget
curl -X GET https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf \
  -H 'Accept: */*'

```

```javascript--nodejs
const request = require('node-fetch');

const headers = {
  'Accept':'*/*'
};

fetch('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf',
{
  method: 'GET',
  headers: headers
})
.then(function(body) {
    console.log(body);
});
```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => '*/*'
}

result = RestClient.get 'https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf',
  params: {
  }, headers: headers

p JSON.parse(result)
```

```python
import requests
headers = {
  'Accept': '*/*'
}

r = requests.get('https://api.waiverforever.com/openapi/v1/waiver/{waiver_id}/pdf', params={
}, headers = headers)

print r.json()
```

`GET /waiver/{waiver_id}/pdf`

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


## Template

<a name="schematemplate"></a>

```json
{
  "title": "string",
  "id": "string",
  "disabled": true,
  "created_at": 0,
  "update_at": 0
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|template title
id|string|true|template id
disabled|boolean|true|true if disabled by user
created_at|integer|true|created timestamp
update_at|integer|true|updated timestamp


## Waiver

<a name="schemawaiver"></a>

```json
{
  "waiver_id": "string",
  "template_id": "string",
  "template_version": "string",
  "template_title": "string",
  "has_pdf": true,
  "geolocation": {
    "accuracy": 0,
    "latitude": "string",
    "longtitude": "string"
  },
  "pictures": [
    {
      "title": "string",
      "url": "string",
      "timestamp": 0
    }
  ],
  "received_at": 0,
  "signed_at": 0,
  "data": [
    {
      "title": "string",
      "value": "string",
      "type": "name_field"
    }
  ]
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
waiver_id|string|true|waiver id
template_id|string|true|template id
template_version|string|true|template version
template_title|string|true|template title
has_pdf|boolean|true|true if the PDF is available to download
geolocation|[GeoLocation](#schemageolocation)|false|signing location
received_at|integer|true|server received timestamp
signed_at|integer|true|waiver signed timestamp
pictures|[[Picture](#schemapicture)]|false|attached pictures
data|[[Field](#schemafield)]|true|filled fields

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
  "title": "string",
  "value": "string",
  "type": "name_field",
  "first_name": "string",
  "last_name": "string",
  "middle_name": "string"
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
  "title": "string",
  "value": "string",
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
  "title": "string",
  "value": "string",
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
  "title": "string",
  "value": "string",
  "type": "initial_field"
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
  "title": "string",
  "value": "string",
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
  "title": "string",
  "value": "string",
  "type": "checkbox_field"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|checkbox field
value|string|true|checked value
type|string|true|always "checkbox_field"

## ShortAnswerField

<a name="schemashortanswerfield"></a>

```json
{
  "title": "string",
  "value": "string",
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
  "title": "string",
  "value": "string",
  "type": "address_field",
  "first_line": "string",
  "second_lien": "string",
  "city": "string",
  "state": "string",
  "country": "string",
  "zipcode": "string"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|address field title
value|string|true|display value
type|string|true|always "address_field"
first_line|true|false|first line
second_lien|true|false|second line
city|string|true|city
state|string|true|state or province
country|string|false|country
zipcode|string|true|zipcode or postal code

## DateField

<a name="schemadatefield"></a>

```json
{
  "title": "string",
  "value": "string",
  "type": "date_field",
  "year": "string",
  "month": "string",
  "day": "string"
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
  "title": "string",
  "value": "string",
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
  "title": "string",
  "type": "multiple_choice_field",
  "value": [
    "string"
  ]
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
    // same as ordinary fields
  ]
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|container field title
type|string|true|always "container_field"
result_list|[[Field](#schemafield)]|true|child fields set

## Picture

<a name="schemapicture"></a>

```json
{
  "title": "string",
  "url": "string",
  "timestamp": 0
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
title|string|true|picture title
url|string|true|temporary download picture url
timestamp|integer|true|created timestamp


## GeoLocation

<a name="schemageolocation"></a>

```json
{
  "accuracy": 5,
  "latitude": "string",
  "longtitude": "string"
}
```

### Properties

Name|Type|Required|Description
---|---|---|---|
accuracy|integer|true|location accuracy level
latitude|string|true|latitude value
longtitude|string|true|longtitude value
