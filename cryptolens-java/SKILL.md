---
name: cryptolens-java
description: Work on the Cryptolens Java SDK and Java-specific license verification integrations. Use when Codex needs to inspect, modify, review, test, or explain the `Cryptolens/cryptolens-java` repository, especially key activation, get-key flows, offline license strings, machine-code generation, floating licenses, trial keys, user-verification integrations, license-server routing, data objects, analytics events, Maven packaging, or migration away from deprecated `io.cryptolens.legacy.*` classes.
---

# Cryptolens Java

## Overview

Use this skill for work in the Cryptolens Java SDK repository: [github.com/Cryptolens/cryptolens-java](https://github.com/Cryptolens/cryptolens-java).

Treat GitHub as the primary source of truth. If a local checkout is also available, use it as a convenience for editing and validation, but do not assume `cryptolens-java/` exists on disk.

Treat `src/main/java/io/cryptolens/methods` and `src/main/java/io/cryptolens/models` as the supported API surface. Treat `src/main/java/io/cryptolens/legacy` as compatibility-only code: `io.cryptolens.legacy.Cryptolens` is explicitly `@Deprecated`, and new code should not import or extend anything from that package unless the task is specifically about backward compatibility.

Before adding or explaining machine-binding checks, read the shared rule in [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md).

Before adding or explaining floating licensing, read the shared rule in [floating-licenses.md](../cryptolens-sdk-common/references/floating-licenses.md).

Before recommending offline caching or local license files, read [offline-fallback.md](../cryptolens-sdk-common/references/offline-fallback.md).

If an API call returns a populated `APIError.message`, read the shared error table in [api-error-messages.md](../cryptolens-sdk-common/references/api-error-messages.md) before diagnosing the issue.

Before writing examples, troubleshooting steps, or support guidance for product workflows, read [official-workflows.md](references/official-workflows.md) so the generated guidance matches the official Cryptolens docs, not just the repository README.

Start with [official-workflows.md](references/official-workflows.md), then [repo-map.md](references/repo-map.md), then [java-workflows.md](references/java-workflows.md) for current Java-specific guidance and machine-code/version choices.

## Quick Start

1. Classify the request: activation flow, machine-binding, offline cache, docs/examples, packaging, or legacy migration.
2. Read [official-workflows.md](references/official-workflows.md) first for the product-supported flows and caveats from the docs.
3. Read [java-workflows.md](references/java-workflows.md) for Java SDK specifics and deprecated boundaries.
4. Read the GitHub repo README and source files named in [repo-map.md](references/repo-map.md).
5. If a local checkout exists, compare it against GitHub only as needed for editing or validation.
6. Keep code, docs, the example app, and tests aligned in the same pass when public behavior changes.

## Task Guide

### Activation, get-key, and offline verification

Open `methods/Key.java`, `methods/Helpers.java`, `models/ActivateModel.java`, `models/GetKeyModel.java`, `models/DeactivateModel.java`, and `models/LicenseKey.java`.

Preserve these invariants unless the task explicitly changes them:

- `Key.Activate(...)` and `Key.GetKey(...)` force signed responses and return `null` on failure while populating `APIError`.
- `LicenseKey.LoadFromString(...)` verifies the RSA signature before returning a license object.
- `LicenseKey.SaveAsString()` / `LicenseKey.LoadFromString(...)` are the supported offline-license serialization path.
- `Helpers.IsOnRightMachine(...)` is only a meaningful validity gate when the license actually tracks machines. If `MaxNoOfMachines == 0`, machine-binding is not active and the check should not be presented as a general validity test.
- Keep the existing public API naming convention. Even though the Java style is unusual, methods such as `Key.Activate`, `Helpers.GetMachineCode`, and fields such as `LicenseServerUrl` are public API and should not be renamed casually.

When writing sample code, wrappers, or integration snippets:

- Do not introduce new imports from `io.cryptolens.legacy.*`.
- Prefer `io.cryptolens.methods.*` plus `io.cryptolens.models.*`.
- Do not hardcode `3349` or other sample product ids from docs. Make product id, token, RSA public key, and license key configurable or clearly labeled placeholders.
- Prefer creating an `APIError error = new APIError();` and surfacing `error.message` in examples that are intended for troubleshooting.
- Mention cached signed-license fallback for production flows when the user asks for a robust verification design, but ask where the license string should be stored and how long offline use may stay valid before you bake that into code.
- Follow the timing guidance in [official-workflows.md](references/official-workflows.md): verification normally happens on app start, when the user updates the license key, and sometimes periodically.

### Machine code and platform-specific guidance

Open `methods/Helpers.java`, `src/test/java/io/cryptolens/HelpersTest.java`, and the current README/example app before changing platform guidance.

Use these rules:

- Treat `io.cryptolens.legacy.MachineCodeComputer` and any other `io.cryptolens.legacy.*` helper as obsolete for new code.
- `Helpers.GetMachineCode()` is the original default fingerprint path.
- `Helpers.GetMachineCode(2)` is the UUID-based Windows compatibility path used by existing docs and tests when callers want .NET/Python-aligned matching or fewer optional runtime dependencies.
- `Helpers.GetMachineCode(3)` is the newer multi-OS desktop path implemented in the current source. If you move examples or docs to `v=3`, update platform notes and tests in the same change instead of mixing recommendations.
- For Android or other environments where local machine discovery is not appropriate, prefer the overloads that accept an explicit machine-code string: `Helpers.IsOnRightMachine(license, machineCode, ...)`.
- For floating licenses, pass the correct `isFloatingLicense` / `allowOverdraft` flags to `IsOnRightMachine(...)`, and default overdraft to zero unless the user explicitly wants it.

### Data objects, events, messages, products, and subscription usage

Use the method classes in `src/main/java/io/cryptolens/methods/`:

- `Data.java` for data objects on keys and machine codes.
- `AI.java` for `RegisterEvent`.
- `Message.java` for broadcast messages.
- `ProductMethods.java` for `GetProducts`.
- `Subscription.java` for metered usage recording.
- `RequestModel.LicenseServerUrl` on request models when routing through a self-hosted license server.

When editing docs or examples, preserve the model-based calling convention instead of rebuilding raw HTTP requests by hand.

For analytics and event-registration guidance, follow [official-workflows.md](references/official-workflows.md):

- Prefer `AI.RegisterEvent`.
- Supply at least a meaningful `FeatureName` and either `Key` or `MachineCode`.
- Include `ProductId` when multiple products exist.
- Use `Value` and `Currency` for transaction-style events.
- Do not assume the Java SDK has every helper shown in .NET docs; if metadata helpers are missing, populate metadata explicitly or explain the gap.

### Examples, docs, and support fixes

Use [official-workflows.md](references/official-workflows.md) as the primary source for supported flows and product-level guidance, then use the repo README, `example-app/src/Main.java`, and the Java method/model classes to translate that guidance into current Java SDK usage.

The official docs currently cover:

- standard key verification
- offline verification with periodic refresh and air-gapped certificates
- trial keys
- username/password user verification as a product flow
- event registration and analytics data collection
- Java-specific installation, deactivation, floating licenses, and license-server routing
- adjacent Unity and Rhino/Grasshopper platform notes

Apply these rules when turning the docs into Java guidance:

- For offline verification, keep Java examples centered on `LicenseKey.SaveAsString()` and `LicenseKey.LoadFromString(...)`, and remember that `LoadFromString(...)` does not validate `ProductId`.
- For manual activation files or certificates used by non-.NET consumers, follow the doc-backed "Other languages" format guidance in [official-workflows.md](references/official-workflows.md).
- For trial keys, prefer `Key.CreateTrialKey(...)` followed by normal activation, and keep the machine-binding check.
- For user verification, do not invent Java SDK classes that are not present in the current repo. If the docs describe a product-level login flow without a matching Java wrapper, prefer Web API or backend guidance first, then activate the chosen license in Java if node-locking is needed.
- If the user asks about Unity or Rhino/Grasshopper, use the adjacent-platform notes in [official-workflows.md](references/official-workflows.md) for support context, but do not paste .NET-specific APIs into Java code.

### Legacy migration and review work

If the task touches `src/main/java/io/cryptolens/legacy`:

- Assume the goal is compatibility or migration, not feature growth.
- Prefer moving callers toward `Key`, `Helpers`, and `models.LicenseKey`.
- Call out the type distinction clearly: `io.cryptolens.models.LicenseKey` is the supported model, while `io.cryptolens.legacy.LicenseKey` is compatibility-only.
- If you update README examples, remove or avoid deprecated imports in the same pass.

### Packaging and release-adjacent work

Use `pom.xml` as the source of truth for artifact metadata and dependencies.

Keep in mind:

- Artifact coordinates currently come from `io.cryptolens:cryptolens`.
- `gson` is a runtime dependency.
- `oshi-core` is optional and only affects some machine-code helper paths.
- Avoid dependency churn unless the task clearly needs it.
- Keep the README, example app, and Maven metadata aligned when public installation guidance changes.

## Validation

If a local checkout is available, prefer the smallest proof that matches the change:

- `mvn -q -DskipTests compile` for API or packaging edits
- focused test execution for pure helper/model behavior
- example-app compile or smoke updates for docs/example changes

Be careful with the existing test suite:

- `KeyTest` and some other tests use `apikeys.json` and live API calls, so they are not safe as unconditional offline validation.
- `HelpersTest` is the best starting point for machine-code and feature-helper changes.
- Avoid running live activation flows unless safe test credentials are already present and the task explicitly calls for end-to-end verification.

If no local checkout is available, limit the task to review, explanation, GitHub-based code changes, or documentation guidance unless a writable repository context is provided.

## Resources

Read [official-workflows.md](references/official-workflows.md) for the official documentation-backed flows, caveats, and adjacent-platform notes.

Read [repo-map.md](references/repo-map.md) for the file map and task routing.

Read [java-workflows.md](references/java-workflows.md) for Java-specific guidance, current method/class choices, and migration notes.
