# Devolens (formerly Cryptolens) Skills

This repository is a bundle of Devolens (formerly Cryptolens) skills intended to be used together, packaged for Claude Code and Codex plugin marketplace installs.

The language-specific skills depend on `cryptolens-sdk-common` for shared licensing rules, cross-language invariants, and doc-backed guidance that should stay aligned across SDKs. The current layout is bundle-first rather than individually packaged by default, so the `../cryptolens-sdk-common/...` links are intentional — all skills live as siblings inside `skills/`.

## Repository Layout

```
.claude-plugin/
  marketplace.json   # Claude Code plugin marketplace manifest
  plugin.json        # Claude Code plugin manifest
.agents/
  plugins/
    marketplace.json # Codex marketplace manifest
install.sh           # Codex marketplace bootstrap installer
plugins/
  devolens/          # Codex plugin metadata
skills/              # canonical skill bundle, auto-discovered by Claude Code
scripts/             # installer helpers
```

## Claude Code Marketplace

Install the Devolens plugin from the GitHub marketplace with:

```
/plugin marketplace add Cryptolens/skills
/plugin install devolens@devolens
```

Run both commands inside Claude Code. The first registers this repository as a plugin marketplace (reading `.claude-plugin/marketplace.json`); the second installs the `devolens` plugin, which bundles all skills under `skills/` (`cryptolens-sdk-common`, the language-specific skills, and the `license-*` aliases).

To install from a local clone instead of GitHub, point `marketplace add` at the repository path:

```
/plugin marketplace add /path/to/skills
/plugin install devolens@devolens
```

Restart Claude Code after installing so the new skills are discovered.

## Codex Marketplace

Review the installer source at:

https://github.com/Cryptolens/skills/blob/main/install.sh

Install the Devolens Codex marketplace with the raw script URL:

```bash
curl -fsSL https://raw.githubusercontent.com/Cryptolens/skills/main/install.sh | bash
```

The installer places a local marketplace at `~/.codex/marketplaces/devolens`. If that marketplace already exists, the installer leaves it unchanged. Restart Codex, open Plugin Directory, then install `Devolens Licensing` (`devolens`).

The Codex installer builds the plugin's `skills/` directory from the canonical `skills/` bundle during installation. Keep `skills/` as the single source of truth.

## Skill Layout

Canonical implementation skills (under `skills/`):

- `cryptolens-sdk-common`: shared/common skill with cross-language licensing rules and reference material.
- `cryptolens-dotnet`: .NET-specific guidance, repo mapping, and examples.
- `cryptolens-java`: Java-specific guidance, repo mapping, and examples.
- `cryptolens-python`: Python-specific guidance, repo mapping, and examples.

Intent-based alias skills (under `skills/`):

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
3. If a matching language-specific skill exists, read it for repo-aware guidance, current API usage, and implementation details.
4. If no language-specific skill exists for the target stack, stay in `cryptolens-sdk-common` and use Web API 3 over HTTPS instead of inventing SDK APIs.
5. Use the language-specific reference files to translate the shared/product guidance into SDK-specific examples and troubleshooting steps when a matching SDK skill exists.

If you copy only one language folder without `cryptolens-sdk-common`, the existing cross-skill relative links will break. The alias skills also depend on the canonical bundle and should be installed with it.

## Canonical External Docs

These local skills distill and adapt the official Devolens (formerly Cryptolens) documentation. Treat these two `llms.txt` endpoints as the canonical external documentation inputs for the skill set:

- [Web API 3 docs `llms.txt`](https://app.cryptolens.io/docs/api/v3/llms.txt)
- [Help center `llms.txt`](https://help.cryptolens.io/llms.txt)

For unsupported languages or direct HTTP integrations, use the full documentation inputs: [Web API 3 docs `llms-full.txt`](https://app.cryptolens.io/docs/api/v3/llms-full.txt) and [Help center `llms-full.txt`](https://help.cryptolens.io/llms-full.txt).

The local `official-workflows.md` and `official-examples.md` files are not competing sources of truth. They are language-shaped derivatives that condense the official docs into guidance that matches the current SDK repositories.

## Agent Metadata

Each skill may include `agents/openai.yaml`.

These files do not replace the skill content. They provide OpenAI/Codex-oriented display metadata and default prompting so the same repository can support both skill content and agent-oriented discovery.

## How To Read This Repo

For most tasks:

1. Start with `cryptolens-sdk-common` if the task touches product-wide licensing behavior or assumptions shared across SDKs.
2. Move to the language-specific skill for repository and API details.
3. Use the local reference files as distilled guidance grounded in the official docs above.
