---
name: cryptolens-sdk-common
description: Shared cross-language guidance for Cryptolens client SDKs and integrations. Use when Codex works on any Cryptolens SDK or app integration and needs language-agnostic licensing rules, especially key-verification best practices, offline verification with cached signed license files or strings, activation semantics, node-locking, machine-binding assumptions, or other behavior that should stay consistent across Python, .NET, Java, Node.js, and future SDKs.
---

# Cryptolens SDK Common

## Overview

Use this skill for rules that should stay consistent across Cryptolens SDKs.

Start with [licensing-invariants.md](references/licensing-invariants.md) and [offline-fallback.md](references/offline-fallback.md), and treat those rules as the default unless a language-specific repo clearly documents different behavior.

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
