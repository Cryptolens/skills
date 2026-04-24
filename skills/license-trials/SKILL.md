---
name: license-trials
description: Help with Devolens/Cryptolens trial-license workflows, verified trials, trial key creation, activation expectations, feature-lock caveats, and trial-related machine binding. Use when Codex needs to design, implement, review, or explain trial-license behavior across .NET, Python, Java, Node.js, and related integrations.
---

# License Trials

Use this skill for verified trials, trial key creation, activation behavior, feature-lock caveats, and machine-binding checks that apply to trial licenses.

Start with `cryptolens-sdk-common` for shared licensing assumptions, then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- unsupported language or no matching SDK skill: route through `cryptolens-sdk-common` and the Web API 3 HTTP docs instead of inventing SDK APIs
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK or platform is clear

For doc-backed trial flows, use the language-specific reference files together with these canonical external docs:

- `https://help.cryptolens.io/llms.txt`
- `https://app.cryptolens.io/docs/api/v3/llms.txt`

Keep this skill thin. Use the canonical skills for SDK-specific implementation details and examples.
