---
name: cryptolens-python
description: Work on the Cryptolens Python SDK and Python-specific license verification integrations. Use when Codex needs to inspect, modify, review, test, or explain the `Cryptolens/cryptolens-python` repository, especially key activation, offline license files, floating licenses, trial keys, machine-code generation, Python 2 compatibility, packaging, examples, or troubleshooting Python activation, signature, proxy, or SSL issues.
---

# Cryptolens Python

## Overview

Use this skill for work in the Cryptolens Python SDK repository: [github.com/Cryptolens/cryptolens-python](https://github.com/Cryptolens/cryptolens-python).

Treat GitHub as the primary source of truth. If a local checkout is also available, use it as a convenience for editing and validation. Start with [repo-map.md](references/repo-map.md), then open only the repo files needed for the task. Keep the SDK's public API and tuple-based return conventions stable unless the task explicitly asks for a breaking change.

Before adding or explaining machine-binding checks, read the shared Cryptolens rule in [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md).

Before adding or explaining floating licensing, read the shared floating-license rule in [floating-licenses.md](../cryptolens-sdk-common/references/floating-licenses.md).

If an SDK call returns a non-empty message string, read the shared error table in [api-error-messages.md](../cryptolens-sdk-common/references/api-error-messages.md) before diagnosing the issue.

Before writing examples or support guidance for verification workflows, read [official-workflows.md](references/official-workflows.md) so the generated guidance matches the official Cryptolens docs, not just the repository README.

## Quick Start

1. Classify the request before editing.
2. Read [official-workflows.md](references/official-workflows.md) first for the supported flows and doc-backed caveats.
3. Read the repo README for Python-specific examples and support notes.
4. Read `licensing.md` for method signatures and expected behavior.
5. Open the implementation files named in [repo-map.md](references/repo-map.md).
6. If the task touches legacy environments, inspect `cryptolens_python2.py` too.
7. Keep code, docs, and examples aligned in the same pass.

## Task Guide

### Activation and verification

Open `licensing/methods.py`, `licensing/models.py`, and `licensing/internal.py`.

Preserve these invariants unless the task explicitly changes them:

- Verify signatures before returning a `LicenseKey` from `Key.activate` or `Key.get_key`.
- Preserve tuple-shaped failure paths such as `(None, message)` or `(False, message)` instead of raising for expected API failures.
- Preserve offline activation through `LicenseKey.save_as_string()` and `LicenseKey.load_from_string(...)`.
- Preserve machine-binding behavior in `Helpers.GetMachineCode(...)` and `Helpers.IsOnRightMachine(...)`.
- Treat `v=2` machine-code behavior as important because the public examples rely on it for .NET-compatible matching.
- Treat `Helpers.IsOnRightMachine(...)` as meaningful only when the license has **Maximum Number of Machines > 0**. If that value is `0`, machine codes are not added to the license and the check does not apply as a general validity test. See [the shared invariant](../cryptolens-sdk-common/references/licensing-invariants.md) and the support article it links to.
- If the returned `message` is not empty, interpret it against [the shared API error table](../cryptolens-sdk-common/references/api-error-messages.md) before assuming the Python SDK implementation is wrong.

When writing sample code, wrappers, or integration snippets:

- Do not hardcode `product_id=3349` or any other example product id from the upstream docs.
- Make `product_id` user-supplied through a function argument, config value, environment variable, or clearly labeled placeholder such as `YOUR_PRODUCT_ID`.
- Prefer the same treatment for other tenant-specific values such as access tokens, RSA public keys, and license keys.
- For floating-license examples, default overdraft to `0` and only show `max_overdraft` with a value greater than `0` when the user explicitly wants overdraft behavior.
- Reflect the official timing guidance from [official-workflows.md](references/official-workflows.md): key verification usually happens on app start, when the user changes the license key, and sometimes periodically.

Update the README examples if the call pattern, arguments, or expected verification checks change.

### Examples, docs, and support fixes

Use [official-workflows.md](references/official-workflows.md) as the primary source for supported flows and product-level guidance, then use the repo `README.md` and `licensing.md` to translate that guidance into Python-specific code.

The official docs currently cover:

- standard activation
- offline activation with `.skm` files
- floating licenses
- trial keys
- username/password user verification
- event registration and analytics data collection
- custom server endpoint
- proxy and SSL troubleshooting

Use `licensing.md` as the broader API reference. Align docs to the implementation, or implementation to docs, explicitly. Do not leave them drifting apart.

For floating-license questions, point to [Cryptolens Documentation: Floating licenses](https://help.cryptolens.io/licensing-models/floating).

For offline verification, prefer the official certificate model described in [official-workflows.md](references/official-workflows.md): signed activation responses can be cached, refreshed periodically, or delivered manually for air-gapped devices.

For verified trials, follow the official flow in [official-workflows.md](references/official-workflows.md): create the trial key first, then activate it as usual, and use a separate trial-token setup when feature lock controls the trial duration.

For user verification, follow the official flow in [official-workflows.md](references/official-workflows.md): use username/password to fetch licenses first, then activate the selected license only if machine-binding or node-locking is needed.

For data collection, prefer the official event model in [official-workflows.md](references/official-workflows.md): use `AI.RegisterEvent`, include a useful feature name and either key or machine code, and reserve value/currency for transaction-style analytics.

If the user asks about Unity, Rhino/Grasshopper, or adjacent plugin-host environments, use the adjacent-platform notes in [official-workflows.md](references/official-workflows.md) for support context, but do not copy .NET-specific API signatures into Python code.

### Python 2 and legacy hosts

Treat `cryptolens_python2.py` as a separate compatibility path used in older integrations such as Autodesk Maya and some IronPython/Revit setups.

Inspect both Python 3 and Python 2 codepaths before declaring a cross-runtime fix complete. If the change is intentionally Python-3-only, say that clearly in the final handoff so the Python 2 path is not assumed to be covered.

### Packaging and release-adjacent work

Use `setup.py` for package metadata and versioning.

Avoid adding new dependencies unless there is a strong reason. The repo is mostly standard-library based, and compatibility matters.

Update package metadata and installation/docs together if public imports, package naming, or install instructions change.

## Validation

If a local checkout is available, run validation from the repo root. If the repo is only available through GitHub, restrict the task to review, explanation, or documentation updates unless you also have a writable repository integration.

Prefer the smallest check that proves the change:

- import smoke tests for packaging or import issues
- targeted unit checks for serialization, signature freshness, or machine matching
- focused script execution for documentation and example updates

Treat `test.py` and `test_signature.py` as starting points, not as a complete automated safety net. Inspect them before relying on them.

Avoid live activation calls in automated validation unless the task explicitly provides safe test credentials and requires end-to-end verification.

## Resources

Read [repo-map.md](references/repo-map.md) for the file map, common task routing, and repo-specific gotchas.

Read [official-workflows.md](references/official-workflows.md) for the official documentation-backed flows and adjacent platform notes used by this skill.
