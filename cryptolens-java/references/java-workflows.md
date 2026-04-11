# Java Workflows

Read [official-workflows.md](official-workflows.md) first for the product docs, supported end-user flows, and adjacent-platform notes. Use this file for Java-SDK-specific translation and repo-aware guidance.

## Default Stance

- Prefer `io.cryptolens.methods.*` and `io.cryptolens.models.*` in new code.
- Avoid `io.cryptolens.legacy.*` unless the task is explicitly about backward compatibility or migration.
- Trust `src/main/java` over the README when the docs and code disagree, then bring docs back into alignment in the same change.

## Verification Flows

### Online activation

Use `Key.Activate(token, rsaPubKey, new ActivateModel(productId, key, machineCode), error)` when the app should both verify the license and register the current machine.

Use `Key.GetKey(token, rsaPubKey, new GetKeyModel(productId, key), error)` when you need a signed key lookup without activation.

Populate `APIError` in troubleshooting-oriented examples so callers can inspect `error.message`.

### Offline fallback

Use `license.SaveAsString()` to persist the signed activation response.

Use `LicenseKey.LoadFromString(rsaPubKey, licenseString)` or `LoadFromString(..., signatureExpirationIntervalDays)` to verify and reload it locally.

If you are designing a production-ready flow, keep online verification as the primary path and use cached signed data as a fallback instead of switching to ad hoc unsigned local state.

## Machine-Code Selection

- `Helpers.GetMachineCode()` is the original default helper.
- `Helpers.GetMachineCode(2)` is the UUID-based Windows compatibility path used by existing docs and tests.
- `Helpers.GetMachineCode(3)` is the newer source-level multi-OS desktop path with Windows, macOS, and Linux handling.
- `Helpers.IsOnRightMachine(license, machineCode, ...)` is the safest option when the caller already has a stable machine identifier or the environment is not suited for local discovery.

Use `v=2` when compatibility with the official Java docs, existing Windows/.NET/Python guidance, or `cryptolens-android.jar` matters.

Use `v=3` only when you are intentionally adopting the newer cross-platform behavior and are prepared to update docs/tests that still describe the older choice.

Do not present `IsOnRightMachine(...)` as a universal license-validity check when `license.MaxNoOfMachines == 0`.

## Floating Licenses

Create the activation request with the `ActivateModel` overload that includes `floatingTimeInterval` and, optionally, `maxOverdraft`.

When validating the returned license locally, use the `Helpers.IsOnRightMachine(...)` overloads that pass `isFloatingLicense=true`, and set `allowOverdraft=true` only when overdraft is actually enabled.

Default `maxOverdraft` to `0` in examples unless the user explicitly wants overdraft behavior.

## License Server Routing

Most request models inherit `LicenseServerUrl` from `RequestModel`.

When routing through a self-hosted license server, instantiate the model first, set `model.LicenseServerUrl`, then call the usual method such as `Key.GetKey(...)`.

Prefer that pattern over creating duplicate overloads or custom HTTP code in examples.

## User Verification Translation

The official product docs describe username/password user verification, but the current Java SDK repo surface may not expose a dedicated `UserAuth` helper alongside `Key`, `Data`, `AI`, `Message`, `ProductMethods`, and `Subscription`.

When the Java wrapper is absent, do not invent Java SDK classes. Prefer:

- backend or Web API login to retrieve the user's licenses
- selection of the correct license for the product
- normal Java SDK activation afterwards if machine binding or node-locking is needed

## Legacy Migration

Treat `io.cryptolens.legacy.Cryptolens` as deprecated and compatibility-only.

Preferred replacements:

- `legacy.Cryptolens.activate(...)` -> `Key.Activate(...)`
- `legacy.LicenseKey` -> `models.LicenseKey`
- legacy helper/request plumbing -> request models plus `Key`, `Data`, `Message`, `AI`, `ProductMethods`, or `Subscription`

When migrating callers, update imports first. The package names are similar enough that mixed imports are easy to miss.

## Validation Tips

- Prefer compile-only checks or targeted helper tests for structural changes.
- Use `HelpersTest` first for machine-code or feature-helper updates.
- Treat `KeyTest` and any test depending on `apikeys.json` as live integration tests, not guaranteed offline unit tests.
- If you change public examples, update both `README.md` and `example-app/src/Main.java` together.
