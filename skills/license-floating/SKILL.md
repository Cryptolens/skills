---
name: license-floating
description: Help with Devolens/Cryptolens floating-license workflows, seat reuse timing, overdraft behavior, activation and deactivation expectations, and floating-license machine checks. Use when Codex needs to design, implement, review, or explain floating licenses across .NET, Python, Java, Node.js, and related integrations.
---

# License Floating

Use this skill for floating-license activation, time-window behavior, overdraft defaults, and release/deactivation flows.

Start with [floating-licenses.md](../cryptolens-sdk-common/references/floating-licenses.md) and [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md) in `cryptolens-sdk-common`.

Then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK or platform is clear

Use the local reference files as distilled guidance, but treat these as the canonical external docs:

- `https://help.cryptolens.io/llms.txt`
- `https://app.cryptolens.io/docs/api/v3/llms.txt`

Keep this skill thin. Use the canonical skills for SDK-specific implementation guidance.
