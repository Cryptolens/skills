---
name: license-key-verification
description: Help with Devolens/Cryptolens software licensing tasks centered on license key verification, activation, signature checks, product ID checks, expiration checks, and machine-binding assumptions. Use when Codex needs to design, implement, review, or explain license key verification across .NET, Python, Java, Node.js, and related integrations.
---

# License Key Verification

Use this skill for general license key verification flows, including activation, signature validation, feature checks, expiration checks, and machine-binding assumptions.

Start with [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md) in `cryptolens-sdk-common`.

Then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- unsupported language or no matching SDK skill: route through `cryptolens-sdk-common` and the Web API 3 HTTP docs instead of inventing SDK APIs
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK or platform is clear

For product-level examples and doc-backed flow expectations, use the local language-specific reference files together with these canonical external docs:

- `https://help.cryptolens.io/llms.txt`
- `https://app.cryptolens.io/docs/api/v3/llms.txt`

Keep this skill thin. Use the canonical skills for SDK-specific implementation guidance.
