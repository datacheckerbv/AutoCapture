# Migration guide v9

## Breaking change: lenient document validation

Through v8, AutoCapture rejected a document that did not match
`ALLOWED_DOCUMENTS`: it showed a "document not allowed" screen, and for a
document type it could not confidently classify it raised an error in the
`not_allowed` category through `onError`.

As of v9 AutoCapture is lenient. It never shows that screen and never raises
that error from capture. Document validation still steers the experience, it no
longer blocks it:

- **Confident match** (the requested type, and the requested side if you asked
  for a specific side): captures automatically and completes, exactly as before.
- **Unknown type, or not the requested side**: the SDK does not capture
  automatically. The manual capture button lets the person capture the document
  themselves, and a manual capture always asks for a flip so both sides are
  collected.

Document-type rejection is not removed, it moves server-side. DataChecker's
document classification service validates the captured document during
processing and rejects unsupported types. The SDK is lenient; the backend is
not.

### Before (v8)

```javascript
AC.init({
    ...,
    onError: function(error) {
        if (error.code.startsWith('not_allowed')) {
            // An unrecognised / disallowed document ended the session here.
            showWrongDocumentMessage();
        }
    }
});
```

### After (v9)

```javascript
AC.init({
    ...,
    // The SDK no longer emits a `not_allowed` error, and no longer blocks the
    // person on an unrecognised document. Document-type rejection happens
    // server-side when the captured images are processed by DataChecker's
    // document classification service.
    onComplete: function(result) {
        submitForProcessing(result);
    }
});
```

If your `onError` handler branched on the `not_allowed` category, remove or
repurpose that branch: it no longer fires.

### Custom language files

The `not_allowed` overlay message has been removed from the SDK (the default and
all bundled languages), because it is never shown anymore. If you supply your own
`LANGUAGE` object with a `not_allowed` entry, that entry is now unused. No action
is required, an unused key is silently ignored, but you can drop `not_allowed`
from your language files to keep them in sync with the SDK.

## Breaking change: manual capture button on by default

To make sure no one is ever left unable to continue on a document the SDK will
not auto-capture, the `CAPTURE_BTN_AFTER` default changed from off (`0`) to
`10000` ms. The manual capture button now appears 10 seconds after the camera
starts if no capture has completed. A confidently recognised document still
captures automatically well before then.

If you relied on the manual capture button never appearing, set it back to `0`:

```javascript
AC.init({
    ...,
    CAPTURE_BTN_AFTER: 0, // never show the manual capture button
});
```
