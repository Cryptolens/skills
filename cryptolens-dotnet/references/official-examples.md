# Official Examples

Use this file when the user asks for guidance based on these official docs:

- [Unity 3D / Mono](https://help.cryptolens.io/getting-started/unity)
- [Rhino 3D / Grasshopper](https://help.cryptolens.io/getting-started/rhino-ceros-3d-grashopper)
- [Key verification](https://help.cryptolens.io/examples/key-verification)
- [Offline verification](https://help.cryptolens.io/examples/offline-verification)
- [Verified trials](https://help.cryptolens.io/examples/verified-trials)
- [User verifications](https://help.cryptolens.io/examples/user-verification)
- [Data collection](https://help.cryptolens.io/examples/data-collection)

These examples are distilled from the docs, but aligned to the current .NET repo. Prefer the exact repo types and method names when the docs and source differ slightly.

## Namespaces

Use these imports for most C# examples:

```csharp
using SKM.V3;
using SKM.V3.Methods;
using SKM.V3.Models;
```

Use the VB.NET equivalents:

```vbnet
Imports SKM.V3
Imports SKM.V3.Methods
Imports SKM.V3.Models
```

If the example filters a returned license collection, also import `System.Linq` / `Imports System.Linq`.

## Key Verification

The official key-verification guide uses `Key.Activate(...)`, `Sign = true`, and a machine code. Keep that flow, but avoid tenant-specific placeholders such as product `3349`.

For ordinary .NET examples, prefer neutral placeholders and check at least signature validity. Add `HasNotExpired()` or feature checks when the example is meant to show a complete gating decision.

### C#

```csharp
var licenseKeyValue = "YOUR_LICENSE_KEY";
var rsaPubKey = "YOUR_RSA_PUBLIC_KEY";
var accessToken = "YOUR_ACCESS_TOKEN";
var productId = YOUR_PRODUCT_ID;

var machineCode = Helpers.GetMachineCodePI();

var result = Key.Activate(token: accessToken, parameters: new ActivateModel
{
    Key = licenseKeyValue,
    ProductId = productId,
    Sign = true,
    MachineCode = machineCode
});

var license = result?.LicenseKey?
    .HasValidSignature(rsaPubKey)?
    .HasNotExpired();

if (result == null || result.Result == ResultType.Error || !license.IsValid())
{
    Console.WriteLine("The license does not work.");
}
else
{
    Console.WriteLine("The license is valid.");
}
```

### VB.NET

```vbnet
Dim licenseKeyValue = "YOUR_LICENSE_KEY"
Dim rsaPubKey = "YOUR_RSA_PUBLIC_KEY"
Dim accessToken = "YOUR_ACCESS_TOKEN"
Dim productId = YOUR_PRODUCT_ID

Dim machineCode = Helpers.GetMachineCodePI()

Dim result = Key.Activate(token:=accessToken, parameters:=New ActivateModel With {
    .Key = licenseKeyValue,
    .ProductId = productId,
    .Sign = True,
    .MachineCode = machineCode
})

Dim license As LicenseKey = Nothing

If result IsNot Nothing AndAlso result.Result <> ResultType.Error Then
    license = result.LicenseKey.HasValidSignature(rsaPubKey).HasNotExpired()
End If

If license Is Nothing OrElse Not license.IsValid() Then
    Console.WriteLine("The license does not work.")
Else
    Console.WriteLine("The license is valid.")
End If
```

### Notes

- The official guide shows `Helpers.GetMachineCodePI(v: 2)`. Use that only when the task explicitly needs parity with another SDK, especially Python.
- If the example includes machine binding, mention that it only applies when **Maximum Number of Machines > 0**.
- If signature verification does not succeed on the target runtime or host, switch to the Unity-style fallback shown below: call the `Key.Activate(...)` overload that returns `RawResponse`, then verify it with `LicenseKey.FromResponse(...)`.
- If the target is Unity/Mono or another cross-platform host with signature-verification issues on `ActivateModel`, see the Unity section below.

## Offline Verification

The official offline-verification guide describes two patterns:

- cache a signed response after a successful online activation and reuse it for a short offline grace period
- load a pre-generated activation file or certificate for air-gapped environments

### Periodic Online Check With Cached Offline File

#### C#

```csharp
var result = Key.Activate(token: accessToken, parameters: new ActivateModel
{
    Key = licenseKeyValue,
    ProductId = productId,
    Sign = true,
    MachineCode = machineCode
});

if (result == null || result.Result == ResultType.Error ||
    !result.LicenseKey.HasValidSignature(rsaPubKey).IsValid())
{
    var cachedLicense = new LicenseKey().LoadFromFile("licensefile.skm");

    if (cachedLicense?.
        HasValidSignature(rsaPubKey, 3)?
        .HasNotExpired()?
        .IsValid() == true)
    {
        Console.WriteLine("The cached license is valid.");
    }
    else
    {
        Console.WriteLine("The license does not work.");
    }
}
else
{
    result.LicenseKey.SaveToFile("licensefile.skm");
    Console.WriteLine("The license is valid.");
}
```

#### VB.NET

```vbnet
Dim result = Key.Activate(token:=accessToken, parameters:=New ActivateModel With {
    .Key = licenseKeyValue,
    .ProductId = productId,
    .Sign = True,
    .MachineCode = machineCode
})

If result Is Nothing OrElse result.Result = ResultType.Error OrElse
   Not result.LicenseKey.HasValidSignature(rsaPubKey).IsValid() Then

    Dim cachedLicense = New LicenseKey().LoadFromFile("licensefile.skm")

    If cachedLicense IsNot Nothing AndAlso
       cachedLicense.HasValidSignature(rsaPubKey, 3).HasNotExpired().IsValid() Then
        Console.WriteLine("The cached license is valid.")
    Else
        Console.WriteLine("The license does not work.")
    End If
Else
    result.LicenseKey.SaveToFile("licensefile.skm")
    Console.WriteLine("The license is valid.")
End If
```

### Air-Gapped Activation File

The official guide shows `LoadFromFile(...)` plus a machine check. In new examples, prefer an explicit machine code or `Helpers.IsOnRightMachine(...)` instead of old `SKGL.SKM.getSHA256` usage.

#### C#

```csharp
var machineCode = Helpers.GetMachineCodePI();
var licenseFile = new LicenseKey().LoadFromFile("ActivationFile.skm");

var valid = licenseFile?
    .HasValidSignature(rsaPubKey, 365)?
    .HasNotExpired()?
    .IsValid() == true &&
    Helpers.IsOnRightMachine(licenseFile, machineCode);

if (valid)
{
    Console.WriteLine("License verification successful.");
}
else
{
    Console.WriteLine("The license file is not valid or has expired.");
}
```

#### VB.NET

```vbnet
Dim machineCode = Helpers.GetMachineCodePI()
Dim licenseFile = New LicenseKey().LoadFromFile("ActivationFile.skm")

Dim valid = licenseFile IsNot Nothing AndAlso
            licenseFile.HasValidSignature(rsaPubKey, 365).HasNotExpired().IsValid() AndAlso
            Helpers.IsOnRightMachine(licenseFile, machineCode)

If valid Then
    Console.WriteLine("License verification successful.")
Else
    Console.WriteLine("The license file is not valid or has expired.")
End If
```

## Verified Trials

The official guide uses `Key.CreateTrialKey(...)` followed by normal activation and a machine check.

### C#

```csharp
var machineCode = Helpers.GetMachineCodePI();

var trial = Key.CreateTrialKey(accessToken, new CreateTrialKeyModel
{
    ProductId = productId,
    MachineCode = machineCode
});

if (trial == null || trial.Result == ResultType.Error)
{
    Console.WriteLine("Could not create the trial key.");
    return;
}

var activation = Key.Activate(accessToken, new ActivateModel
{
    ProductId = productId,
    Key = trial.Key,
    Sign = true,
    MachineCode = machineCode,
    Metadata = true
});

var valid = activation != null &&
            activation.Result != ResultType.Error &&
            activation.LicenseKey.HasValidSignature(rsaPubKey).IsValid() &&
            Helpers.IsOnRightMachine(activation.LicenseKey, machineCode) &&
            activation.Metadata?.LicenseStatus?.IsValid == true;
```

### VB.NET

```vbnet
Dim machineCode = Helpers.GetMachineCodePI()

Dim trial = Key.CreateTrialKey(accessToken, New CreateTrialKeyModel With {
    .ProductId = productId,
    .MachineCode = machineCode
})

If trial Is Nothing OrElse trial.Result = ResultType.Error Then
    Console.WriteLine("Could not create the trial key.")
    Return
End If

Dim activation = Key.Activate(accessToken, New ActivateModel With {
    .ProductId = productId,
    .Key = trial.Key,
    .Sign = True,
    .MachineCode = machineCode,
    .Metadata = True
})

Dim valid = activation IsNot Nothing AndAlso
            activation.Result <> ResultType.Error AndAlso
            activation.LicenseKey.HasValidSignature(rsaPubKey).IsValid() AndAlso
            Helpers.IsOnRightMachine(activation.LicenseKey, machineCode) AndAlso
            activation.Metadata IsNot Nothing AndAlso
            activation.Metadata.LicenseStatus IsNot Nothing AndAlso
            activation.Metadata.LicenseStatus.IsValid
```

### Notes

- The official trial guide emphasizes the machine check. Keep that note because trials are device-bound.
- The guide says trial duration defaults to 15 days and can be changed through an access token feature lock. Mention that when the user asks about trial duration.

## User Verification

The official `user-verification` guide describes username/password authentication using `UserAuth.Login(...)`. This is different from the browser-based `UserAccount.GetLicenseKeys(...)` flow in the repo.

### C#

```csharp
var login = UserAuth.Login(accessToken, new LoginUserModel
{
    UserName = userName,
    Password = password
});

if (!Helpers.IsSuccessful(login))
{
    Console.WriteLine("User authentication failed.");
    return;
}

var license = login.LicenseKeys.FirstOrDefault(x => x.ProductId == productId);

if (license == null)
{
    Console.WriteLine("No license for this product was found.");
    return;
}

var machineCode = Helpers.GetMachineCodePI();
var activeOnThisMachine = Helpers.IsOnRightMachine(license, machineCode);
```

### VB.NET

```vbnet
Dim login = UserAuth.Login(accessToken, New LoginUserModel With {
    .UserName = userName,
    .Password = password
})

If Not Helpers.IsSuccessful(login) Then
    Console.WriteLine("User authentication failed.")
    Return
End If

Dim license = login.LicenseKeys.FirstOrDefault(Function(x) x.ProductId = productId)

If license Is Nothing Then
    Console.WriteLine("No license for this product was found.")
    Return
End If

Dim machineCode = Helpers.GetMachineCodePI()
Dim activeOnThisMachine = Helpers.IsOnRightMachine(license, machineCode)
```

### Notes

- Use an access token with `UserAuthNormal` inside the app, matching the official guide.
- If the user asks for the linked-customer browser authorization flow instead, switch to `SKM.V3.Accounts.UserAccount.GetLicenseKeys(...)`.

## Data Collection

The official data-collection guide uses `AI.RegisterEvent(...)` with `FeatureName`, an event name, and OS metadata.

### C#

```csharp
var machineCode = Helpers.GetMachineCodePI();

AI.RegisterEvent(accessToken, new RegisterEventModel
{
    EventName = "start",
    FeatureName = "YearReportGenerator",
    Key = licenseKeyValue,
    MachineCode = machineCode,
    ProductId = productId,
    Metadata = Helpers.GetOSStats()
});
```

### VB.NET

```vbnet
Dim machineCode = Helpers.GetMachineCodePI()

AI.RegisterEvent(accessToken, New RegisterEventModel With {
    .EventName = "start",
    .FeatureName = "YearReportGenerator",
    .Key = licenseKeyValue,
    .MachineCode = machineCode,
    .ProductId = productId,
    .Metadata = Helpers.GetOSStats()
})
```

### Notes

- The official guide uses `Helpers.GetMachineCode()`. For new general examples, prefer `Helpers.GetMachineCodePI()` unless the task is specifically about older Windows-only behavior.
- `ProductId` is optional for single-product setups, but keeping it explicit is safer in reusable examples.

## Unity

The official Unity guide says to use `Cryptolens.Licensing.CrossPlatform.dll` and notes that some Unity versions also need `Newtonsoft.Json.dll`.

Use these rules:

- Prefer `Cryptolens.Licensing.CrossPlatform` for Unity and Mono.
- If signature verification with the `ActivateModel` overload is unreliable on the target Unity runtime, use the string-returning `Key.Activate(...)` overload and then `LicenseKey.FromResponse(...)`.
- The same Unity-style fallback is acceptable outside Unity too when signature verification fails unexpectedly on a host runtime but the rest of the activation flow is correct.
- For offline verification in Unity, call `LoadFromFile(...)` or `LoadFromString(...)` with the RSA public key.
- If the target uses IL2CPP or restricted platform APIs, `Helpers.GetMACAddress()` may be a safer fallback than machine-code helpers.

### Unity-Friendly C#

```csharp
var response = Key.Activate(
    token: accessToken,
    productId: productId,
    key: licenseKeyValue,
    machineCode: machineCode);

var license = LicenseKey.FromResponse(rsaPubKey, response);

if (!license.IsValid())
{
    Console.WriteLine("The license does not work.");
}
```

## Rhino / Grasshopper

The official Rhino/Grasshopper guide says Rhino 8 may not work well with a normal NuGet install. It recommends referencing the built `Cryptolens.Licensing.dll` manually from the `netstandard2.0` output and installing `Newtonsoft.Json` 13.

Use these rules:

- Treat Rhino/Grasshopper as a platform-specific packaging issue first, not as a licensing-logic issue.
- Reuse the normal key-verification examples after the assembly reference is fixed.
- If the task is about Rhino 8 specifically, mention the manual `dll` reference workaround from the official guide.
