# Offline Fallback

## Overview

Use this reference when the user asks for a production-ready key-verification flow rather than only the smallest possible online example.

Across Cryptolens SDKs, a common best practice is:

1. verify online first using `Key.Activate` or the SDK equivalent
2. persist the signed license artifact locally
3. if later runs cannot verify online because internet access is unavailable, fall back to the stored signed artifact
4. enforce an offline-validity window using signature-expiry support on the SDK's load or verification methods

This keeps the basic licensing flow simple for end users while still requiring periodic online verification.

## Simple Example vs Production Pattern

If the user asks only for a key-verification example:

- provide the normal online verification example only
- add a short note that cached offline fallback is often recommended in production
- ask whether they want that version too

Do not automatically turn a simple example request into a full offline-caching design.

If the user explicitly wants the production-ready version, include the cached offline fallback pattern in the response or implementation.

## Required Clarifying Questions

If the user wants offline fallback, ask for these decisions before finalizing the guidance:

- how the signed license should be stored:
  file, serialized string, in-memory cache, config store, database, or another mechanism
- the exact storage location:
  file path, directory, cache key, table, bucket, or storage system
- how long the cached license may remain valid offline before internet access is required again

Do not assume defaults such as app-data, current directory, alongside the executable, or an arbitrary offline-validity period unless the user explicitly chooses them.

## Signature Expiry

Load-from-file, load-from-string, or SDK-equivalent verification methods can usually enforce a signature-expiry window.

Use that capability to define how long the locally cached license remains acceptable offline. Once the expiry window is exceeded, the application should require internet access and a fresh online verification.

## Language-Agnostic Wording

When writing shared guidance, use terms such as:

- `Key.Activate` or SDK equivalent
- signed license object, signed response, license file, or serialized license string
- load or verify from the cached artifact
- signature-expiry support

Avoid wording that assumes one SDK's exact APIs, file helpers, or storage conventions apply to all SDKs.
