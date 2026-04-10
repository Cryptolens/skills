# API Error Messages

These message strings are shared across Cryptolens SDKs.

When an SDK returns a non-empty `message` field or equivalent error string, use the table below to explain the likely cause before inventing a repo-specific diagnosis.

| Error message | Description |
| --- | --- |
| `Unable to authenticate` | The access token is wrong. It is also shown if the subscription has expired. API access requires an active subscription. |
| `Something went wrong. Please contact support@cryptolens.io and we will try to fix it.` | A temporary server error. Try again with a new request. |
| `No active subscription found. Please contact support.` | No active subscription is associated with the account and thus the API call failed. The error can be fixed by updating billing information and adding a valid payment method on the billing page. |
| `Access denied` | The access token is correct but it does not have sufficient permission. Make sure that if you want to call a method such as `GetKey`, the access token has that permission. |
| `Not enough permission and/or key not found.` | If the product really contains the license key and the access token has permission to call the method, this can often be fixed by setting **Key Lock = -1** when creating the access token. This is especially relevant for data-object-related methods. |

## How To Use This Table

- Apply this mapping across SDKs unless there is clear evidence that a language wrapper is adding its own custom message.
- Prefer these documented causes before suggesting code changes in the SDK.
- If the message is not in this table, continue with normal SDK-specific debugging.
