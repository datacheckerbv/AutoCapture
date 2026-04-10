# Migration guide v7

## Breaking change: `onError` now receives an object

In v7, the `onError` callback receives a structured object `{ code, stack }` instead of a plain string. Any code that reads the error as a string must be updated.

### Before (v6)

```javascript
AC.init({
    ...,
    onError: function(error) {
        // error was a plain string, e.g. "capture_error"
        if (error === 'capture_error') {
            showCameraRetry();
        }
        console.log(error);
    }
});
```

### After (v7)

```javascript
AC.init({
    ...,
    onError: function(error) {
        // error is now { code, stack }
        // code format: "category:NNNN", e.g. "capture_error:4004"
        if (error.code.startsWith('capture_error')) {
            showCameraRetry();
        }
        console.error(error.code, error.stack);
    }
});
```

## Error code categories

Use the category prefix of `error.code` to determine the type of error. The numeric suffix is for support diagnostics — include it when reporting issues.

| Category         | Description                               | Recommended action                                |
| ---------------- | ----------------------------------------- | ------------------------------------------------- |
| `capture_error`  | Camera or processing failure              | Show camera retry UI or prompt for permission     |
| `init_error`     | Initialization failed                     | Prompt user to refresh the page                   |
| `model_error`    | ML model failed to load                   | Check network connection, retry initialization    |
| `not_allowed`    | Document type not permitted               | Prompt user to use an accepted document type      |
| `opencv_error`   | Required component failed to load         | Prompt user to refresh or try a different browser |
| `settings_error` | Invalid configuration or version mismatch | Verify SDK configuration and hosted assets        |
| `token_error`    | Token missing, invalid, or not permitted  | Verify token credentials                          |

## New language keys

Five new keys were added for error category messages. Custom language files do not need to include them — the SDK falls back to English defaults — but adding them provides translated messages in the overlay.

```javascript
var LANGUAGE = {
    // ... existing keys ...

    // New in v7
    init_error:     "Initialization failed. Please refresh the page.",
    settings_error: "Configuration error. Please contact support.",
    token_error:    "Authorization failed. Please try again later.",
    opencv_error:   "A required component failed to load. Please refresh the page.",
    model_error:    "Failed to load required resources. Please check your connection.",
}
```
