---
name: license-subscriptions
description: Help with Devolens/Cryptolens subscription licensing, expiry checks, renewal logic, grace periods, ExtendLicense renewals, BlockKey cancellation handling, Stripe webhook flows, and subscription access review across .NET, Python, Java, Node.js, direct Web API integrations, and related stacks.
---

# License Subscriptions

Use this skill for subscription-backed licensing, expiration checks, renewal handling, cancellation handling, support/update entitlement, and billing-webhook-driven license updates.

Start with `cryptolens-sdk-common` for shared licensing assumptions, then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- unsupported language, backend-only renewal flow, or no matching SDK skill: route through `cryptolens-sdk-common` and the Web API 3 HTTP docs instead of inventing SDK APIs
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK, backend, or payment provider is clear

Use these product docs and canonical inputs for subscription decisions:

- `https://help.cryptolens.io/licensing-models/subscription`
- `https://help.cryptolens.io/payments/thirdparty/external-providers`
- `https://app.cryptolens.io/docs/api/v3/llms-full.txt`
- `https://help.cryptolens.io/llms-full.txt`

Before implementing, identify whether the subscription gates product access, updates, support, or specific features; how much grace period to allow; which payment event extends the license; and which cancellation or failed-payment event blocks or downgrades the license.

Keep this skill thin. Use the language skills for in-app expiry checks and the Web API docs for backend methods such as `ExtendLicense`, `BlockKey`, and related payment-provider automation.
