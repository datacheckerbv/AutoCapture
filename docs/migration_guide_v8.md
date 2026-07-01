# Migration guide v8

## Breaking change: generic runtime errors moved to `runtime_error:8001`

The generic runtime catch-all error (`PROCESSING_ERROR`), reported when an
unexpected error occurs that is not one of the specific categorised failures,
has moved from `capture_error:4001` to its own category `runtime_error:8001`.

As a result:

- `capture_error` is now **camera-only**. It no longer fires for generic
  runtime errors.
- A new `runtime_error` category covers unexpected/generic failures and shows a
  generic overlay message instead of the camera-specific one.
- The code `4001` is **retired** and will not be reused.

### Before (v7)

```javascript
AC.init({
    ...,
    onError: function(error) {
        // Generic runtime errors arrived as "capture_error:4001"
        if (error.code.startsWith('capture_error')) {
            showCameraRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

### After (v8)

```javascript
AC.init({
    ...,
    onError: function(error) {
        if (error.code.startsWith('capture_error')) {
            // Now strictly a camera failure
            showCameraRetry();
        } else if (error.code.startsWith('runtime_error')) {
            // Generic/unexpected runtime error: show a generic retry UI
            showGenericRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

**Action required** if your `onError` handler either:

- matches the exact string `capture_error:4001` → change it to
  `runtime_error:8001`; or
- routes generic runtime errors through the `capture_error` prefix → those now
  arrive under `runtime_error`. Add a `runtime_error` branch.

Handlers that match `capture_error` purely for camera handling need no change.

## Error code categories

Use the category prefix of `error.code` to determine the type of error. The
numeric suffix is for support diagnostics; include it when reporting issues.

| Category         | Description                               | Recommended action                                |
| ---------------- | ----------------------------------------- | ------------------------------------------------- |
| `capture_error`  | Camera failure                            | Show camera retry UI or prompt for permission     |
| `init_error`     | Initialization failed                     | Prompt user to refresh the page                   |
| `model_error`    | ML model failed to load                   | Check network connection, retry initialization    |
| `not_allowed`    | Document type not permitted               | Prompt user to use an accepted document type      |
| `opencv_error`   | Required component failed to load         | Prompt user to refresh or try a different browser |
| `runtime_error`  | Unexpected/generic runtime error          | Show generic retry UI                             |
| `settings_error` | Invalid configuration or version mismatch | Verify SDK configuration and hosted assets        |
| `token_error`    | Token missing, invalid, or not permitted  | Verify token credentials                          |

## New language key

One new key, `runtime_error`, was added for the generic runtime error message.
The built-in language files shipped with the SDK already include it. If you
supply your own custom language object, you do not need to add it (the SDK
falls back to the English default), but adding it provides a translated message
in the overlay.

```javascript
var LANGUAGE = {
    // ... existing keys ...

    // New in v8
    runtime_error: "Something went wrong. Please try again.",
}
```

## Behavioural change: manual capture bypasses validation checks

When the user manually triggers a capture (force capture / capture button), the
SDK now bypasses the allowed-document-type (`ALLOWED_DOCUMENTS`) and
document-flip checks so a manually requested capture always completes. A
document that has already been flipped is still tracked to avoid capturing the
same side twice.

This is in addition to the existing behaviour where manual capture also
bypasses the environment/exposure and focus quality checks. No integration
changes are required, but be aware that a manual capture can now produce an
image of a document type not listed in `ALLOWED_DOCUMENTS`. Validate the
returned document server-side if that matters for your flow.
