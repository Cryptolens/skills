---
name: license-offline
description: Help with Devolens/Cryptolens software licensing workflows that require offline license verification, cached signed license files or strings, air-gapped activation, manual activation files, or offline fallback behavior. Use when Codex needs to design, implement, review, or explain offline license verification across .NET, Python, Java, Node.js, and related integrations.
---

# License Offline

Use this skill for offline license verification, cached license artifacts, air-gapped delivery, and manual activation flows.

Start with [offline-fallback.md](../cryptolens-sdk-common/references/offline-fallback.md) and [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md) in `cryptolens-sdk-common`.

Then route to the language-specific skill that matches the task:

- .NET: `cryptolens-dotnet`
- Python: `cryptolens-python`
- Java: `cryptolens-java`
- no language chosen yet: stay in `cryptolens-sdk-common` until the target SDK or platform is clear

Use the local reference files as distilled guidance, but treat these as the canonical external docs:

- `https://help.cryptolens.io/llms.txt`
- `https://app.cryptolens.io/docs/api/v3/llms.txt`

Keep this skill thin. Do not duplicate implementation details that already live in the canonical skills.
