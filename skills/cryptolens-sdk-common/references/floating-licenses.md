# Floating Licenses

## Default Overdraft Rule

When generating code, docs, wrappers, or support guidance for floating licenses in any Cryptolens SDK:

- default overdraft to `0`
- do not add `max_overdraft`, `MaxOverdraft`, or equivalent parameters unless the user explicitly wants overdraft behavior
- if the SDK requires the parameter to be present, set it to `0` by default
- only use a value greater than `0` when the user explicitly asks to allow exceeding the maximum number of concurrent devices

## Node-Locking Still Applies

Floating licensing still depends on **Maximum Number of Machines > 0**.

If that value is `0`, machine codes are not added to the license and machine-binding checks do not work as a general validity check.

## Documentation Link

If you or the user have questions about floating licenses, use this page:

[Cryptolens Documentation: Floating licenses](https://help.cryptolens.io/licensing-models/floating)
