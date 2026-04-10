# Official Workflows

Use these official docs as the primary source for supported licensing flows and expected behavior. Use the GitHub repo and `licensing.md` to map those workflows onto Python-specific APIs.

## Core Docs

- [Key verification](https://help.cryptolens.io/examples/key-verification)
- [Offline verification](https://help.cryptolens.io/examples/offline-verification)
- [Verified trials](https://help.cryptolens.io/examples/verified-trials)
- [User verification](https://help.cryptolens.io/examples/user-verification)
- [Data collection](https://help.cryptolens.io/examples/data-collection)

## Key Verification

The official guidance says key verification code normally runs:

- on app start
- when the user updates the license key
- periodically for some licensing models

Do not hardcode the license key in generated app code. Treat it as user input, stored configuration, or another user-managed secret.

## Offline Verification

The official offline model is based on the signed response from `Key.Activate` or `Key.GetKey`. Treat that response as a certificate or license file.

Support two main patterns:

- periodic online verification with a cached certificate fallback
- air-gapped verification using a license file delivered by USB, dashboard download, activation forms, or a backend/API workflow

When generating offline examples:

- explain the freshness window used by `LoadFromString(..., days)` or the equivalent SDK method
- prefer periodic refresh over "verify once forever"
- for air-gapped scenarios, call out that machine-locking must be configured if the code checks that the certificate belongs to the current machine

## Verified Trials

The official trial flow is:

1. call `CreateTrialKey`
2. receive either a new trial key or the previously issued one
3. activate/verify that key as usual
4. if machine-binding is checked, ensure the trial belongs to the current machine

Important defaults and caveats:

- trial duration is 15 days by default
- the duration can be changed by using an access token whose feature lock is set to the number of trial days
- use a separate access token for `CreateTrialKey`, because the feature lock can interfere with other methods such as `Activate`

## User Verification

Use user verification when:

- customers may have multiple licenses
- the product has both web and desktop experiences

In the app:

- authenticate with username and password
- use a token with `UserAuthNormal` permission only
- retrieve the licenses for that user
- select the relevant product license
- proceed with activation only if you need normal node-locking or machine-binding behavior

If the user wants one credential that maps to many licenses, note that the docs also point to the customer-secret flow as an alternative.

## Data Collection

The official docs say Cryptolens already logs many key and data-object API calls, but extra analytics events can provide richer business insight.

When generating event-tracking guidance:

- use `AI.RegisterEvent`
- include at least `FeatureName` and either `Key` or `MachineCode`
- treat `ProductId` as optional for single-product setups and useful for multi-product setups
- use `Value` and `Currency` for transaction-style events
- mention that callers can fall back to the raw API endpoint when the SDK/platform wrapper is not available

## Adjacent Platform Notes

These docs are not Python implementations, but they are useful for support and cross-SDK comparisons:

- [Unity 3D / Mono](https://help.cryptolens.io/getting-started/unity)
- [Rhino 3D / Grashopper](https://help.cryptolens.io/getting-started/rhino-ceros-3d-grashopper)

Use them when the user asks about hosted plugin environments, platform-specific packaging, or cross-SDK consistency. Do not copy their .NET-only API shapes into Python code.

Useful takeaways:

- Unity uses a special cross-platform .NET build and has Newtonsoft.Json/versioning caveats
- Unity guidance notes Linux/root constraints around machine-code helpers in that environment
- Rhino 8 may require manually referencing the SDK DLL instead of relying on NuGet
- Rhino key-verification logic still follows the same generic key-verification tutorial
