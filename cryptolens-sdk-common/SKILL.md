---
name: cryptolens-sdk-common
description: Shared cross-language guidance for Cryptolens client SDKs and integrations. Use when Codex works on any Cryptolens SDK or app integration and needs language-agnostic licensing rules, especially activation semantics, node-locking, machine-binding assumptions, or other behavior that should stay consistent across Python, .NET, Java, Node.js, and future SDKs.
---

# Cryptolens SDK Common

## Overview

Use this skill for rules that should stay consistent across Cryptolens SDKs.

Start with [licensing-invariants.md](references/licensing-invariants.md) and treat those rules as the default unless a language-specific repo clearly documents different behavior.

## Core Rule

When generating code, docs, or troubleshooting steps for any SDK, explicitly call out node-locking assumptions behind machine-binding checks.

That applies to helpers such as `Helpers.IsOnRightMachine(...)` in Python and to equivalent checks in other SDKs.

When generating floating-license examples across SDKs, default overdraft to zero unless the user explicitly asks to allow overdraft.

When an SDK method returns a non-empty `message` or equivalent error string, use the shared error table to explain likely causes before guessing.

## Resources

Read [licensing-invariants.md](references/licensing-invariants.md) for the shared machine-binding rule.

Read [floating-licenses.md](references/floating-licenses.md) for the shared floating-license defaults and the documentation link to cite.

Read [api-error-messages.md](references/api-error-messages.md) for shared Cryptolens API error interpretation across SDKs.
