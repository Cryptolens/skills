# Repo Map

Canonical repository: [github.com/Cryptolens/cryptolens-dotnet](https://github.com/Cryptolens/cryptolens-dotnet)

Use repo-relative paths below. If a local checkout exists, those paths are relative to the repo root. If not, search and open the same paths directly in [github.com/Cryptolens/cryptolens-dotnet](https://github.com/Cryptolens/cryptolens-dotnet). Do not assume the repo is cloned locally.

## Main Files

- `README.md`: public installation, compatibility, troubleshooting, and example guidance; useful, but it still contains legacy `SKGL.SKM` examples near the bottom
- `Cryptolens.Licensing/Cryptolens.Licensing.csproj`: NuGet metadata, target frameworks, `SYSTEM_MANAGEMENT`, and package dependencies
- `Cryptolens.Licensing/SKMv3/Key.cs`: current Web API 3 license-key operations such as activate, get key, create key, trial key, deactivate, and key updates
- `Cryptolens.Licensing/SKMv3/Helpers.cs`: current helper surface for machine codes, platform detection, password hashing, floating-license calculations, and machine checks
- `Cryptolens.Licensing/LicenseRelated/LicenseKey.cs`: core `LicenseKey` model, `FromResponse(...)`, refresh logic, and data-object mutation helpers
- `Cryptolens.Licensing/ExtensionMethods.cs`: fluent helpers for `LicenseKey`, offline save/load, signature checks, feature checks, and machine matching
- `Cryptolens.Licensing/Models/WebAPIModels.cs`: request and response models for Web API 3 methods
- `Cryptolens.Licensing/Models/UserLoginAuthModels.cs`: models used by user-account authentication flows
- `Cryptolens.Licensing/UserAccountAuth/UserLoginAuth.cs`: current user-account authentication implementation in `SKM.V3.Accounts`
- `Cryptolens.Licensing/SKM.cs`: obsolete Web API 2 and `SKGL` compatibility layer; inspect only when a task explicitly concerns legacy behavior
- `Cryptolens.Licensing/SKMv3/ExtensionMethods.cs`: additional Web API 3 helpers and extension methods; note where they still delegate to legacy paths
- `Tutorials/v.101-beta.md`: historical beta documentation; use only to understand older naming or migration context

## Common Task Routing

- Activation or verification bug: inspect `SKMv3/Key.cs`, `SKMv3/Helpers.cs`, `LicenseRelated/LicenseKey.cs`, and `ExtensionMethods.cs` together.
- Offline license-file issue: inspect `LicenseRelated/LicenseKey.cs` plus `ExtensionMethods.cs`.
- Machine-code or cross-platform issue: inspect `SKMv3/Helpers.cs`, the README compatibility notes, and the project file's `SYSTEM_MANAGEMENT` settings.
- Floating-license behavior: inspect `SKMv3/Helpers.cs`, `SKMv3/Key.cs`, and the shared `floating-licenses.md` reference in `cryptolens-sdk-common`.
- User-account authentication issue: inspect `UserAccountAuth/UserLoginAuth.cs` and `Models/UserLoginAuthModels.cs`.
- Packaging or dependency change: inspect `Cryptolens.Licensing.csproj` plus the README install section.
- Legacy-compatibility question: inspect `SKM.cs`, `SKGL` extension methods, and old README examples, but keep them fenced off from new-code guidance.

## Behavioral Notes

- The repo exposes a modern `SKM.V3` surface and a legacy `SKGL` surface. Treat `SKM.V3` as the default for new work.
- `SKM.cs` is marked `[Obsolete]`, and several newer helpers still reference it for backward-compatible behaviors. Watch for accidental regressions when changing fluent helpers.
- `Helpers.GetMachineCodePI()` is the preferred cross-platform machine-code path. `Helpers.GetMachineCode()` is obsolete in `SYSTEM_MANAGEMENT` builds.
- `LicenseKey.FromResponse(...)` verifies the signed `RawResponse` and returns `null` on verification failure.
- `LicenseKey.LoadFromString(...)` can deserialize either a signed `RawResponse` blob or a serialized `LicenseKey` and returns `null` on parse or signature failure.
- `license.IsOnRightMachine()` without an explicit machine code is not the best default for new code because it can route through older SHA1 and `SKGL.SKM` behavior. Prefer `Helpers.IsOnRightMachine...` or explicit machine codes.
- `license.HasNotExpired(checkWithInternetTime: true)` relies on legacy `SKGL.SKM.TimeCheck()` under the hood. Call out that dependency if you surface that option.
- Machine-binding checks only make sense when the license is node-locked with **Maximum Number of Machines > 0**.

## Validation Notes

- Prefer targeted `dotnet build` commands over full-solution builds because the repo spans multiple frameworks and eras.
- Start with `Cryptolens.Licensing/Cryptolens.Licensing.csproj -f netstandard2.0` for shared logic, then add a Windows/.NET Framework target review if the change touches `SYSTEM_MANAGEMENT` code.
- Avoid treating `Tutorials/` as executable validation material.
- Do not run live activation flows unless safe credentials are provided for the task.
