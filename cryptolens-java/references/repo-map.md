# Repo Map

Treat the GitHub repository as canonical: [github.com/Cryptolens/cryptolens-java](https://github.com/Cryptolens/cryptolens-java). If a local checkout exists, use the same paths below relative to the repo root, but do not assume the checkout is present.

## Top Level

- `pom.xml`: Maven coordinates, dependency versions, compiler level, and publishing plugins.
- `README.md`: User-facing examples and installation notes. Useful, but do not assume it is fully up to date with current code.
- `example-app/src/Main.java`: Small runnable example that shows the intended SDK calling style.
- `apikeys.json`: Local test credentials for integration-style tests. Treat as sensitive and optional.

## Supported API Packages

- `src/main/java/io/cryptolens/methods/Key.java`: Activation, get-key, deactivation, trial-key creation, and license extension.
- `src/main/java/io/cryptolens/methods/Helpers.java`: Machine-code generation, machine matching, feature checks, expiry checks, and response helpers.
- `src/main/java/io/cryptolens/methods/Data.java`: Data-object CRUD plus increment/decrement flows for key or machine-code metadata.
- `src/main/java/io/cryptolens/methods/AI.java`: `RegisterEvent`.
- `src/main/java/io/cryptolens/methods/Message.java`: `GetMessages`.
- `src/main/java/io/cryptolens/methods/ProductMethods.java`: `GetProducts`.
- `src/main/java/io/cryptolens/methods/Subscription.java`: `RecordUsage`.

## Model and Infrastructure Packages

- `src/main/java/io/cryptolens/models/LicenseKey.java`: Supported license model plus `SaveAsString()` and `LoadFromString(...)`.
- `src/main/java/io/cryptolens/models/*Model.java`: Request DTOs. Most API method calls are model-driven.
- `src/main/java/io/cryptolens/models/RequestModel.java`: Base request model that exposes `LicenseServerUrl`.
- `src/main/java/io/cryptolens/internal/*`: Shared HTTP/request plumbing and result wrappers. Treat as implementation detail unless the task is about internals.

## Legacy Package

- `src/main/java/io/cryptolens/legacy/Cryptolens.java`: Deprecated compatibility entry point. Do not use in new examples.
- `src/main/java/io/cryptolens/legacy/LicenseKey.java`: Compatibility-only type; do not confuse it with `io.cryptolens.models.LicenseKey`.
- `src/main/java/io/cryptolens/legacy/*`: Older request/signature helpers kept for backward compatibility and migration work.

## Tests

- `src/test/java/io/cryptolens/HelpersTest.java`: Best local starting point for machine-code and feature-helper behavior.
- `src/test/java/io/cryptolens/KeyTest.java`: Integration-heavy activation and get-key scenarios. Reads `apikeys.json`.
- `src/test/java/io/cryptolens/DataTest.java`: Data-object flows.
- `src/test/java/io/cryptolens/MessageTest.java`: Broadcast message retrieval.
- `src/test/java/io/cryptolens/ProductTest.java`: Product listing.
- `src/test/java/io/cryptolens/SubscriptionTest.java`: Usage-recording flow.

## Practical Routing

- For activation or offline caching questions, open `Key.java`, `Helpers.java`, and `models/LicenseKey.java`.
- For license-server routing, inspect the relevant request model and `RequestModel.LicenseServerUrl`.
- For docs or example fixes, compare `README.md` and `example-app/src/Main.java` against current source before editing.
- For migration work, inspect both `methods`/`models` and `legacy` so you can describe the safe replacement path.

## Gotchas

- Public API names intentionally use PascalCase methods and public fields. Preserve them unless a breaking API change is explicitly desired.
- `legacy` exists alongside the supported API, so import collisions are easy. Check package names carefully.
- The README and example app may lag behind `Helpers.GetMachineCode(3)` or other newer source-level behavior.
- Some tests require live credentials and network access; do not assume the whole suite is safe for offline validation.
