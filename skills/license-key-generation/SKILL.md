---
name: license-key-generation
description: Help with Devolens/Cryptolens backend license key creation, CreateKey API usage, license templates, server-side access-token scope, payment-success license delivery, customer-linked licenses, product IDs, periods, features, maximum machines, and license provisioning workflows.
---

# License Key Generation

Use this skill for creating license keys from a backend, payment flow, admin tool, migration script, CRM workflow, or external automation.

Start with `cryptolens-sdk-common` for shared licensing assumptions, then route based on where key creation happens:

- backend or unsupported language: use Web API 3 over HTTPS and avoid inventing SDK APIs
- .NET backend or SDK repo task: `cryptolens-dotnet`
- Python backend or SDK repo task: `cryptolens-python`
- Java backend or SDK repo task: `cryptolens-java`
- no platform chosen yet: stay in `cryptolens-sdk-common` until the backend, payment provider, or automation platform is clear

Use these product docs and canonical inputs for key-generation decisions:

- `https://help.cryptolens.io/examples/key-generation`
- `https://help.cryptolens.io/payments/thirdparty/external-providers`
- `https://app.cryptolens.io/docs/api/v3/CreateKey`
- `https://app.cryptolens.io/docs/api/v3/llms-full.txt`
- `https://help.cryptolens.io/llms-full.txt`

Never put a `CreateKey` access token in distributed client code. Treat key generation as a server-side or trusted-automation workflow, and ask how the generated key should be delivered and stored.

Before implementing, identify product id, period/expiry behavior, feature flags or template, maximum machines, customer association, payment/order id mapping, and access-token permissions.

Keep this skill thin. Use Web API docs for endpoint parameters and the canonical skills for any app-side verification that consumes the generated license key.
