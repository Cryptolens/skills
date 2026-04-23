# Official Workflows

Use this file when writing examples, troubleshooting steps, or support guidance so the Java skill stays aligned with the official Cryptolens docs instead of only mirroring the repository README.

Treat `https://app.cryptolens.io/docs/api/v3/llms.txt` and `https://help.cryptolens.io/llms.txt` as the canonical external doc inputs. This file is a Java-shaped distillation of that material, adjusted to match the current repository and SDK surface.

## Source Pages

- Java getting started: <https://help.cryptolens.io/getting-started/java>
- Key verification: <https://help.cryptolens.io/examples/key-verification>
- Offline verification: <https://help.cryptolens.io/examples/offline-verification>
- Trial keys: <https://help.cryptolens.io/examples/verified-trials>
- User verifications: <https://help.cryptolens.io/examples/user-verification>
- Data collection: <https://help.cryptolens.io/examples/data-collection>
- Unity: <https://help.cryptolens.io/getting-started/unity>
- Rhino/Grasshopper: <https://help.cryptolens.io/getting-started/rhino-ceros-3d-grashopper>

## Key Verification

- The official key-verification guide says license verification code normally runs on app start, when the user updates the license key, and sometimes periodically.
- The Java getting-started page shows the Java SDK flow as `Key.Activate(...)` followed by `Helpers.IsOnRightMachine(license, 2)`.
- That machine-binding check assumes node-locking is enabled. If `Maximum Number of Machines` is zero, machine registrations are disabled and `IsOnRightMachine(...)` should not be presented as a general validity test.
- Keep tenant-specific inputs configurable: RSA public key, access token, product id, license key, and machine code.

## Offline Verification

- The official offline-verification guide describes two supported patterns:
  - periodic online verification with a cached signed response
  - air-gapped/manual delivery of a signed certificate or activation file, for example on a USB stick
- For Java, the official getting-started page maps this to `license.SaveAsString()` and `LicenseKey.LoadFromString(rsaPubKey, licenseString[, maxOfflineDays])`.
- The offline-verification guide uses the extra integer parameter as the offline-validity window in days.
- `LicenseKey.LoadFromString(...)` does not validate `ProductId`, so multi-product integrations should check it explicitly after loading.
- When the flow uses downloaded activation files or certificates for non-.NET consumers, the Unity page says the file format should be set to `Other languages`.

## Trial Keys

- The official trial-key docs describe verified trials as device-bound trial keys.
- Default duration is 15 days.
- To change the duration, use an access token whose `FeatureLock` is set to the desired number of days.
- Use a separate access token for `Key.CreateTrialKey`, because the docs warn that `FeatureLock` can interfere with other methods such as activation.
- The official flow is:
  - call `Key.CreateTrialKey(...)`
  - activate the returned key as usual
  - verify that the result belongs to the right machine

## User Verification

- The official docs describe user verification as a product-level username/password flow that returns the licenses attached to a user.
- The documented use cases are:
  - customers with multiple licenses
  - products with both web and desktop experiences
- The docs say the access token should use `UserAuthNormal` in the app and reserve `UserAuthAdmin` for broader/admin flows.
- When translating this into Java guidance, do not invent Java SDK helpers that are not present in the current repo. If the Java SDK does not expose a login wrapper, guide through the Web API or a backend service first, then activate the selected license in Java if node-locking is required.

## Data Collection

- The official data-collection docs say Cryptolens already logs many Web API requests, including key methods except `GetKey`, but custom events provide richer analytics.
- Prefer `AI.RegisterEvent` for Java SDK examples.
- The docs recommend supplying at least:
  - `FeatureName`
  - either `Key` or `MachineCode`
- `ProductId` is optional for single-product setups and useful for multi-product setups.
- For transaction/revenue-style events, the docs say to pass `Value` and `Currency`.
- The docs show a .NET-specific metadata helper in examples. Do not assume an equivalent Java helper exists; provide metadata explicitly when the Java SDK surface supports it.

## Java-Specific Notes From Official Docs

- The Java getting-started page documents two precompiled jars: `cryptolens.jar` and `cryptolens-android.jar`.
- If the user chooses `cryptolens-android.jar`, the docs say `GetMachineCode` and `IsOnRightMachine` should use version `2`.
- The same page documents:
  - floating licenses through `ActivateModel(..., floatingTimeInterval, maxOverdraft)`
  - deactivation through `Key.Deactivate(...)`
  - early deactivation of floating licenses through the extra boolean flag on `DeactivateModel`
  - license-server routing through `model.LicenseServerUrl`

## Adjacent Platform Notes

Use these only as support context when users ask about those hosts. Do not copy their .NET-specific APIs into Java code.

### Unity / Mono

- The official Unity docs recommend the cross-platform .NET library, not the Java SDK.
- They explicitly advise against the `Key.Activate(ActivateModel)` pattern on some Unity/Mono targets because signature verification can fail there; the page uses a platform-specific activation response plus `LicenseKey.FromResponse(...)`.
- For offline verification in Unity, the docs again call out passing the RSA public key and using the `Other languages` license-file format when appropriate.

### Rhino / Grasshopper

- The official Rhino/Grasshopper page says the integration follows the standard key-verification flow.
- It also notes Rhino 8 may not work well with the usual NuGet path and documents a manual .NET DLL reference workaround.
- Treat that as host-specific .NET guidance, not Java SDK guidance.
