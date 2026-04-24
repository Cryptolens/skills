---
name: license-feature-gates
description: Help with Devolens/Cryptolens feature-gated licensing, feature flags, product editions, feature templates, HasFeature checks, data-object-backed feature hierarchies, AddFeature upgrades, and entitlement review across .NET, Python, Java, Node.js, direct Web API integrations, and related stacks.
---

# License Feature Gates

Use this skill for gating app functionality by licensed features, product editions, modules, feature templates, and upgrade/downgrade flows.

Start with `cryptolens-sdk-common` for shared licensing assumptions, then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- unsupported language, backend-only update, or no matching SDK skill: route through `cryptolens-sdk-common` and the Web API 3 HTTP docs instead of inventing SDK APIs
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK, backend, or platform is clear

Use these product docs and canonical inputs for feature-gating decisions:

- `https://help.cryptolens.io/feature/web-ui/feature-templates`
- `https://help.cryptolens.io/feature/web-ui/feature-definitions`
- `https://app.cryptolens.io/docs/api/v3/llms-full.txt`
- `https://help.cryptolens.io/llms-full.txt`

Before implementing, identify the feature map, default-deny behavior, whether features come from built-in feature flags or feature-template data objects, and whether upgrades are handled by the app, backend, payment automation, or dashboard.

Keep this skill thin. Use the canonical skills for SDK-specific implementation details and Web API docs for backend entitlement changes such as adding features.
