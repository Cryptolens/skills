---
name: cryptolens-sdk-common
description: Shared cross-language guidance for Cryptolens software licensing SDKs, direct Web API 3 HTTP integrations, and unsupported-language fallbacks. Use when Codex works on any Cryptolens SDK or app integration and needs language-agnostic licensing rules, especially license key verification best practices, offline license verification with cached signed license files or strings, floating licenses, trial licenses, activation semantics, node-locking, machine-binding assumptions, or behavior that should stay consistent across Python, .NET, Java, Node.js, direct HTTP clients, and future SDKs.
---

# Cryptolens SDK Common

## Overview

Use this skill for rules that should stay consistent across Cryptolens SDKs.

Start with [licensing-invariants.md](references/licensing-invariants.md) and [offline-fallback.md](references/offline-fallback.md), and treat those rules as the default unless a language-specific repo clearly documents different behavior.

## Unsupported Languages And Direct HTTP API

If there is no language-specific Cryptolens/Devolens skill for the user's stack, do not invent SDK-specific APIs.

Use the Web API 3 HTTP endpoints directly and translate the licensing flow into normal HTTPS requests for the target language.

Use these full documentation sources for endpoint-level details:

- `https://app.cryptolens.io/docs/api/v3/llms-full.txt`
- `https://help.cryptolens.io/llms-full.txt`

Preserve the shared invariants in this skill: signature/RSA verification where supported, correct access-token permissions, machine-binding behavior, offline fallback rules, and API error handling.

## Core Rule

When generating code, docs, or troubleshooting steps for any SDK, explicitly call out node-locking assumptions behind machine-binding checks.

That applies to helpers such as `Helpers.IsOnRightMachine(...)` in Python and to equivalent checks in other SDKs.

When generating floating-license examples across SDKs, default overdraft to zero unless the user explicitly asks to allow overdraft.

When an SDK method returns a non-empty `message` or equivalent error string, use the shared error table to explain likely causes before guessing.

For production-ready key verification across SDKs, treat online verification plus a cached signed-license fallback as the recommended default pattern unless the language-specific repo clearly documents a different supported flow.

## Key Verification Best Practice

When the user wants a production-ready verification flow, prefer this cross-SDK pattern:

1. Call the online verification method such as `Key.Activate` or the SDK equivalent.
2. Store the signed license object, signed response, license file, or serialized license string locally.
3. On later runs, if internet access is unavailable or online verification fails because of connectivity, attempt local verification from the stored license artifact.
4. Use signature-expiry support on the SDK's load or verification methods to enforce how long offline use remains valid before internet access becomes mandatory again.

When the user asks only for a key-verification example:

- keep the example simple and focused on the normal online verification flow
- mention that cached offline fallback is often recommended in production
- ask whether they want that version too, and if so, where or how they want to store the license file or string

When the user wants the offline fallback included:

- ask how the signed license should be stored: file, string cache, config store, database, or another mechanism
- ask for the exact storage location, path, or storage system when that matters
- ask how long the cached license may remain valid offline before internet access becomes mandatory
- do not assume a storage location or offline-validity window

Phrase this guidance using SDK-equivalent terminology so it applies across Python, .NET, Java, Node.js, and future SDKs without assuming the same method names everywhere.

## Resources

Read [licensing-invariants.md](references/licensing-invariants.md) for the shared machine-binding rule.

Read [offline-fallback.md](references/offline-fallback.md) for the shared online-verification plus cached-license fallback pattern.

Read [floating-licenses.md](references/floating-licenses.md) for the shared floating-license defaults and the documentation link to cite.

Read [api-error-messages.md](references/api-error-messages.md) for shared Cryptolens API error interpretation across SDKs.
