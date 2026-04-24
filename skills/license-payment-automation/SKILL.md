---
name: license-payment-automation
description: Help with Devolens/Cryptolens payment automation for Stripe, n8n, Zapier, webhooks, external payment providers, license delivery, renewal, cancellation, CRM sync, expiry reminders, CreateKey, ExtendLicense, BlockKey, AddFeature, and MachineLockLimit workflows.
---

# License Payment Automation

Use this skill for connecting payments, CRM, no-code automation, webhooks, and backend jobs to Devolens/Cryptolens license operations.

Start with `cryptolens-sdk-common` for shared licensing and access-token assumptions, then route based on the integration surface:

- n8n or Zapier: use the relevant product docs first, then Web API docs for method details
- custom backend or external payment provider without n8n/Zapier: use Web API 3 over HTTPS and the external-provider guidance
- app-code changes after license delivery: route to the matching language skill
- no provider chosen yet: stay in `cryptolens-sdk-common` until the payment provider, webhook source, or automation tool is clear

Use these product docs and canonical inputs for payment automation:

- `https://help.cryptolens.io/payments/thirdparty/external-providers`
- `https://help.cryptolens.io/payments/thirdparty/zapier-and-n8n`
- `https://help.cryptolens.io/examples/integration-with-n8n`
- `https://help.cryptolens.io/examples/zapier`
- `https://app.cryptolens.io/docs/api/v3/llms-full.txt`
- `https://help.cryptolens.io/llms-full.txt`

For custom payment-provider integrations, prefer the Web API methods named in the external-provider guide: `CreateKey`, `ExtendLicense`, `BlockKey`, `AddFeature`, and `MachineLockLimit`.

Before implementing, identify the trigger event, idempotency key, customer/license mapping, license delivery channel, retry behavior, access-token permissions, and whether license operations happen in a trusted backend or an automation platform.

Keep this skill thin. Use Web API docs for endpoint parameters and the canonical language skills only when the user's application code also needs to verify or consume the resulting license.
