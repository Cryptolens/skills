# Cryptolens Skills

This repository is a bundle of Cryptolens skills intended to be used together.

The language-specific skills depend on `cryptolens-sdk-common` for shared licensing rules, cross-language invariants, and doc-backed guidance that should stay aligned across SDKs. The current layout is bundle-first rather than individually packaged by default, so the `../cryptolens-sdk-common/...` links are intentional.

## Skill Layout

Canonical implementation skills:

- `cryptolens-sdk-common`: shared/common skill with cross-language licensing rules and reference material.
- `cryptolens-dotnet`: .NET-specific guidance, repo mapping, and examples.
- `cryptolens-java`: Java-specific guidance, repo mapping, and examples.
- `cryptolens-python`: Python-specific guidance, repo mapping, and examples.

Intent-based alias skills:

- `license-offline`: entrypoint for offline license verification, cached licenses, and air-gapped/manual activation flows.
- `license-key-verification`: entrypoint for general license key verification and activation flows.
- `license-floating`: entrypoint for floating-license behavior and overdraft questions.
- `license-trials`: entrypoint for verified trials and trial-key workflows.

`cryptolens-sdk-common` is both shared infrastructure for the language-specific skills and a valid standalone skill when the task is language-agnostic, such as explaining product-wide licensing behavior or cross-SDK verification assumptions. The `license-*` skills are thin SEO/discoverability entrypoints that route into the canonical skills rather than replacing them.

## Dependency Model

Use the skills as one bundle unless you explicitly repackage them.

The intended dependency flow is:

1. If the task arrives through an alias such as `license-offline` or `license-floating`, use that skill only as a router into the canonical skills.
2. Read `cryptolens-sdk-common` for shared rules such as machine-binding assumptions, floating-license defaults, offline fallback, and API error interpretation.
3. Read the language-specific skill for repo-aware guidance, current API usage, and implementation details.
4. Use the language-specific reference files to translate the shared/product guidance into SDK-specific examples and troubleshooting steps.

If you copy only one language folder without `cryptolens-sdk-common`, the existing cross-skill relative links will break. The alias skills also depend on the canonical bundle and should be installed with it.

## Canonical External Docs

These local skills distill and adapt the official Cryptolens documentation. Treat these two `llms.txt` endpoints as the canonical external documentation inputs for the skill set:

- [Web API 3 docs `llms.txt`](https://app.cryptolens.io/docs/api/v3/llms.txt)
- [Help center `llms.txt`](https://help.cryptolens.io/llms.txt)

The local `official-workflows.md` and `official-examples.md` files are not competing sources of truth. They are language-shaped derivatives that condense the official docs into guidance that matches the current SDK repositories.

## Agent Metadata

Each skill may include `agents/openai.yaml`.

These files do not replace the skill content. They provide OpenAI/Codex-oriented display metadata and default prompting so the same repository can support both skill content and agent-oriented discovery.

## How To Read This Repo

For most tasks:

1. Start with `cryptolens-sdk-common` if the task touches product-wide licensing behavior or assumptions shared across SDKs.
2. Move to the language-specific skill for repository and API details.
3. Use the local reference files as distilled guidance grounded in the official docs above.
