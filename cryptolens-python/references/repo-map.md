# Repo Map

Canonical repository: [github.com/Cryptolens/cryptolens-python](https://github.com/Cryptolens/cryptolens-python)

Use repo-relative paths below. If a local checkout exists, those paths are relative to the repo root. If not, open the same paths on GitHub.

## Main Files

- `README.md`: public documentation, installation notes, and example verification flows
- `licensing.md`: generated API reference for classes and methods
- `licensing/methods.py`: main Web API methods such as activation, trial keys, customer, data, and user flows
- `licensing/models.py`: `LicenseKey`, `Response`, RSA public key parsing, offline serialization, and signature freshness logic
- `licensing/internal.py`: HTTP requests, RSA verification helpers, proxy and SSL flags, and Python 3 machine-code helpers
- `cryptolens_python2.py`: self-contained Python 2 SDK used for legacy hosts
- `test.py`: manual example script that exercises live activation and offline save/load
- `test_signature.py`: small regression scaffold around signature-date handling
- `setup.py`: package metadata and published version

## Common Task Routing

- Activation or machine-validation bug: inspect `methods.py`, `models.py`, `internal.py`, and the README examples together.
- Offline license-file bug: inspect `models.py` and the README offline activation section.
- Floating-license behavior: inspect `methods.py` and the README floating-license example.
- Trial-key behavior: inspect `methods.py` and the README verified-trial example.
- SSL, proxy, or custom-endpoint support issue: inspect `internal.py` plus the README settings and troubleshooting sections.
- Python 2 or IronPython issue: inspect `cryptolens_python2.py` plus the README Python 2 notes.
- Packaging or release change: inspect `setup.py` plus the README install section.

## Behavioral Notes

- `Key.activate` and `Key.get_key` return tuples rather than raising on expected API failures.
- `Key.activate` can return a third tuple item when `metadata=True`.
- `LicenseKey.load_from_string(...)` returns `None` on parse, signature, or freshness failures.
- `Helpers.GetMachineCode(v=2)` is the documented path in the public activation examples.
- Network behavior can be redirected or loosened through `HelperMethods.server_address`, `proxy_experimental`, and `verify_SSL` in Python 3, while the Python 2 file has its own compatibility-specific request path.

## Validation Notes

- Example scripts may assume real credentials or live endpoints; do not run them blindly.
- Prefer local unit-style checks around signature verification, response parsing, datetime handling, and machine matching.
- Update docs in the same pass if the implementation or supported workflows change.
