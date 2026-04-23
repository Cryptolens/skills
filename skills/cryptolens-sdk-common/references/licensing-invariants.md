# Licensing Invariants

## Machine-Binding Checks Require Node-Locking

When writing, reviewing, or explaining any check that verifies a license belongs to the current machine, assume it only works when the license has **Maximum Number of Machines** set to a value greater than zero.

This includes helpers such as `Helpers.IsOnRightMachine(...)` in Python and any equivalent machine-binding validation in other Cryptolens SDKs.

If **Maximum Number of Machines = 0**:

- machine codes are not added to the license key during activation
- machine-binding checks can return false or appear empty even when activation otherwise succeeded
- this should be explained as node-locking being disabled, not as the SDK being broken

## How To Apply This Rule

Whenever generated code uses a machine-binding check:

- mention that the check assumes **Maximum Number of Machines > 0**
- avoid presenting the check as universally valid for every license configuration
- if the user intentionally allows unlimited machines, omit the machine-binding check or explain that it does not apply
- if the user expects node-locking, tell them to configure **Maximum Number of Machines** to a value greater than zero

## Support Article

Read more: [Cryptolens FAQ: Maximum number of machines](https://help.cryptolens.io/faq#maximum-number-of-machines)
