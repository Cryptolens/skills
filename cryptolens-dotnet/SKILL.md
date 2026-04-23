---
name: cryptolens-dotnet
description: Work on the Cryptolens .NET SDK and .NET-specific software licensing integrations. Use when Codex needs to inspect, modify, review, test, or explain the `Cryptolens/cryptolens-dotnet` repository, especially license key verification, offline license verification, cached license files, Web API 3 activation, floating licenses, trial licenses, machine binding, node-locking, user-account authentication, NuGet packaging, .NET Framework versus .NET Standard behavior, or troubleshooting proxy, TLS, Unity, Mono, or Windows-only SDK issues.
---

# Cryptolens .NET

## Overview

Use this skill for work in the Cryptolens .NET SDK repository: [github.com/Cryptolens/cryptolens-dotnet](https://github.com/Cryptolens/cryptolens-dotnet).

Treat GitHub as the primary source of truth. Do not assume the user has the repo cloned locally. If a local checkout is unavailable, search and inspect files directly in [github.com/Cryptolens/cryptolens-dotnet](https://github.com/Cryptolens/cryptolens-dotnet) by repo-relative path. If a local checkout is also available, use it as a convenience for editing and validation. Start with [repo-map.md](references/repo-map.md), then open only the repo files needed for the task. Keep the SDK's public API stable unless the task explicitly asks for a breaking change.

Before adding or explaining machine-binding checks, read the shared Cryptolens rule in [licensing-invariants.md](../cryptolens-sdk-common/references/licensing-invariants.md).

Before adding or explaining floating licensing, read the shared floating-license rule in [floating-licenses.md](../cryptolens-sdk-common/references/floating-licenses.md).

If an SDK call returns a non-empty `message`, read the shared error table in [api-error-messages.md](../cryptolens-sdk-common/references/api-error-messages.md) before diagnosing the issue.

When the user asks for implementation patterns or snippets based on the official docs, read [official-examples.md](references/official-examples.md). It distills the linked Cryptolens tutorials into current C# and VB.NET guidance and calls out where the docs still show older helper choices.

## Quick Start

1. Classify the request before editing.
2. Read the repo `README.md` first for installation, compatibility, and support caveats.
3. Read [repo-map.md](references/repo-map.md) and route to the relevant `SKMv3`, `LicenseRelated`, or `UserAccountAuth` files.
4. If there is no local checkout, search and open the corresponding files in [github.com/Cryptolens/cryptolens-dotnet](https://github.com/Cryptolens/cryptolens-dotnet) instead of asking the user to clone the repo first.
5. Treat `SKM.cs`, the `SKGL` namespace, and the README `Old examples` section as legacy compatibility material, not templates for new code.
6. Keep code, docs, examples, and package guidance aligned in the same pass.

## Task Guide

### Activation, verification, and offline licensing

Open `Cryptolens.Licensing/SKMv3/Key.cs`, `Cryptolens.Licensing/SKMv3/Helpers.cs`, `Cryptolens.Licensing/LicenseRelated/LicenseKey.cs`, and `Cryptolens.Licensing/ExtensionMethods.cs`.

Preserve these invariants unless the task explicitly changes them:

- Prefer `SKM.V3.Methods.Key`, `SKM.V3.Methods.Helpers`, `SKM.V3.Models.*`, and `SKM.V3.LicenseKey` in new code, docs, and examples.
- Do not introduce new usages of `SKGL.SKM`, `SKGL.ExtensionMethods`, or other Web API 2 helpers unless the task is specifically about legacy compatibility.
- Treat `Cryptolens.Licensing/SKM.cs` as an obsolete compatibility layer. It is marked `[Obsolete]` and should not be the default path for fixes, examples, or new integrations.
- For signed activation flows, prefer the `Key.Activate(...)` overload that returns `RawResponse` together with `LicenseKey.FromResponse(...)` when the user needs a signed, offline-storable license blob.
- If signature verification fails on a target runtime or host even though the activation flow is otherwise correct, treat the Unity-style `RawResponse` + `LicenseKey.FromResponse(...)` approach as an approved fallback and mention it explicitly.
- For offline persistence, prefer `license.SaveAsString()`, `license.LoadFromString(...)`, and `license.LoadFromFile(...)` instead of inventing a custom serialization format.
- Prefer `Helpers.GetMachineCodePI()` for new cross-platform snippets. Use `v=2` only when the task explicitly needs parity with Python or another SDK that expects that format.
- Avoid `Helpers.GetMachineCode()` in new generic samples because the `SYSTEM_MANAGEMENT` build marks it obsolete and it can push callers toward older Windows-only behavior.
- Avoid the parameterless `license.IsOnRightMachine()` extension helper in new code. It falls back to older SHA1 and `SKGL.SKM` paths. Prefer `SKM.V3.Methods.Helpers.IsOnRightMachine(...)`, `Helpers.IsOnRightMachinePI(...)`, or `license.IsOnRightMachine(machineCode, ...)` with an explicit machine code.
- Treat `Helpers.IsOnRightMachine...` checks as meaningful only when **Maximum Number of Machines > 0**. If that value is `0`, explain that node-locking is disabled rather than calling the SDK broken.
- Do not hardcode `productId=3349` or any other tenant-specific value from the upstream docs. Make product ids, access tokens, RSA public keys, and license keys user-supplied or clearly labeled placeholders.
- For floating-license examples, default `MaxOverdraft` to `0` and only use a positive value when the user explicitly wants overdraft behavior.

If the user asks for rollback detection or examples that pass `checkWithInternetTime: true` into `HasNotExpired(...)`, call out that this routes through the legacy `SKGL.SKM.TimeCheck()` path and be explicit about the compatibility tradeoff.

### Cross-platform and machine-code work

Use the repo README and `SKMv3/Helpers.cs` for supported machine-code behavior.

- Prefer `Cryptolens.Licensing.CrossPlatform` for Mono, Unity, Linux, or Mac guidance.
- Keep `Helpers.WindowsOnly = true` limited to the narrow Windows/.NET Framework workaround described in the README. Do not add it to new general-purpose snippets if `GetMachineCodePI()` or an explicit machine code is sufficient.
- If the task changes machine-code generation, verify whether the behavior must stay compatible with Python's `v=2` path or only with current .NET consumers.

### User-account authentication and user verification

Open `Cryptolens.Licensing/SKMv3/User.cs`, `Cryptolens.Licensing/UserAccountAuth/UserLoginAuth.cs`, `Cryptolens.Licensing/Models/WebAPIModels.cs`, and `Cryptolens.Licensing/Models/UserLoginAuthModels.cs`.

- Distinguish the two supported flows instead of mixing them together.
- For username/password verification as described in the official `user-verification` tutorial, prefer `SKM.V3.Methods.UserAuth.Login(...)` with `LoginUserModel`.
- For browser-based delegated authorization that returns all licenses for a linked customer account, use `SKM.V3.Accounts.UserAccount.GetLicenseKeys(...)`.
- Treat `Tutorials/v.101-beta.md` as historical background only. Do not copy its beta-era namespace names or setup steps into new guidance unless the task explicitly asks for old-package compatibility.
- Keep signed-response verification intact when changing `UserAccount.GetLicenseKeys(...)` flows.

### Docs, examples, and support fixes

Use the repo `README.md` for supported install and troubleshooting flows, but read it critically:

- The install, compatibility, TLS, proxy, and package notes are useful starting points.
- The `Old examples` section and any references to `SKGL.SKM` are legacy material. Modernize those examples if the task asks for docs cleanup.
- Prefer the official guides in [official-examples.md](references/official-examples.md) when the user asks for Unity, Rhino/Grasshopper, key verification, offline verification, verified trials, user verification, or data-collection examples.
- If you update user-facing examples, align them with the current `SKM.V3` APIs and the current package names in the same pass.

### Packaging and build-adjacent work

Use `Cryptolens.Licensing/Cryptolens.Licensing.csproj` for package metadata, target frameworks, conditional dependencies, and the `SYSTEM_MANAGEMENT` build flag.

- Keep NuGet metadata, target-framework support, and README install guidance aligned.
- Avoid changing target frameworks or package dependencies unless the task explicitly requires it.
- Be careful when changing code that differs between `SYSTEM_MANAGEMENT` and cross-platform builds.

## Validation

If a local checkout is available, run validation from the repo root. If the repo is only available through GitHub, inspect and search the GitHub repository directly and restrict the task to review, explanation, or documentation updates unless you also have a writable repository integration.

Prefer the smallest check that proves the change:

- targeted `dotnet build` of `Cryptolens.Licensing/Cryptolens.Licensing.csproj`, usually starting with `-f netstandard2.0`
- focused build or review of a Windows target if the change touches `SYSTEM_MANAGEMENT`, `Helpers.WindowsOnly`, or .NET Framework-specific code paths
- small serialization or signature checks when changing `LicenseKey`, `RawResponse`, or offline-file behavior
- focused docs review when only examples or README guidance changed

Avoid relying on the full solution or historical tutorial files as the main safety net. They cover mixed eras of the SDK.

Avoid live activation calls in automated validation unless the task explicitly provides safe test credentials and requires end-to-end verification.

## Resources

Read [repo-map.md](references/repo-map.md) for the file map, task routing, and repo-specific gotchas.

Read [official-examples.md](references/official-examples.md) for current C# and VB.NET example patterns derived from the official Cryptolens docs.
