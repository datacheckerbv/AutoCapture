# Android Integration Guide for AutoCapture Web SDK

This guide walks you through embedding the AutoCapture web SDK in an Android app using WebView. AutoCapture is a JavaScript-based tool — these instructions show how to run it inside a native Android app.

Before proceeding, read the [JavaScript documentation](../../README.md) to understand the SDK configuration options.

## Prerequisites

- Android Studio
- Min SDK 21+ (Android 5.0)
- The AutoCapture `dist/` folder (built or downloaded)

## Step 1: Set Up the Android Project

### 1.1 Add Permissions

In your `AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 1.2 Add Dependencies

In `build.gradle`:

```groovy
dependencies {
    implementation "androidx.webkit:webkit:1.9.0"
    implementation "androidx.appcompat:appcompat:1.6.1"
}
```

### 1.3 Add SDK Assets

Copy the AutoCapture `dist/` folder into your project's `assets` directory:

```text
app/src/main/assets/AutoCapture/dist/
    index.html
    autocapture.obf.js
    assets/
        ...
```

## Step 2: Set Up Listeners

### 2.1 Output Listener

Receives the captured document data from `onComplete`:

```java
public class OutputListener {
    @JavascriptInterface
    public void postMessage(String message) {
        // message is a JSON string containing captured images
        Log.d("AutoCapture", "Output: " + message);
    }
}
```

### 2.2 Error Listener

Receives errors from `onError` and exit events from `onUserExit`:

```java
public class ErrorListener {
    @JavascriptInterface
    public void postMessage(String message) {
        // v7: message is a JSON string with { code, stack }
        Log.e("AutoCapture", "Error/Exit: " + message);
    }
}
```

## Step 3: Configure the WebView

Inside your Activity's `onCreate()`:

```java
webView = findViewById(R.id.webView);

WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
webSettings.setMediaPlaybackRequiresUserGesture(false);
webSettings.setDomStorageEnabled(true);
webSettings.setAllowFileAccessFromFileURLs(true);

// Configure asset loader to serve local files via https://
final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .build();

webView.setWebViewClient(new WebViewClientCompat() {
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        return assetLoader.shouldInterceptRequest(request.getUrl());
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        initAutoCapture(view);
    }
});

// Register JS → Native bridges
webView.addJavascriptInterface(new OutputListener(), "outputListenerHandler");
webView.addJavascriptInterface(new ErrorListener(), "errorListenerHandler");

// Grant camera permissions to WebView
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        Log.d("WebView", consoleMessage.message());
        return true;
    }

    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        request.grant(request.getResources());
    }
});

// Load the SDK
webView.loadUrl("https://appassets.androidplatform.net/assets/AutoCapture/dist/index.html");
```

> **Note:** `WebViewAssetLoader` serves local files via `https://appassets.androidplatform.net`, which allows `fetch()` to work correctly (unlike `file://` URLs).

## Step 4: Initialize the SDK

```java
private void initAutoCapture(WebView view) {
    // Request camera permission if needed
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
            != PackageManager.PERMISSION_GRANTED) {
        ActivityCompat.requestPermissions(this,
            new String[]{Manifest.permission.CAMERA}, CAMERA_REQUEST_CODE);
        return;
    }

    String assetsURL = "https://appassets.androidplatform.net/assets/AutoCapture/dist/assets/";
    String token = "<YOUR SDK TOKEN>";

    String script = "(function() {" +
        "var mount = document.getElementById('AC_mount');" +
        "if (!mount) { mount = document.createElement('div'); mount.id = 'AC_mount'; document.body.appendChild(mount); }" +
        "var ac = new AutoCapture();" +
        "ac.init({" +
        "  CONTAINER_ID: 'AC_mount'," +
        "  LANGUAGE: 'en'," +
        "  TOKEN: '" + token + "'," +
        "  ASSETS_MODE: 'LOCAL'," +
        "  ASSETS_FOLDER: '" + assetsURL + "'," +
        "  ALLOWED_DOCUMENTS: {" +
        "    IDENTITY_CARD: ['FRONT', 'BACK']," +
        "    PASSPORT: ['FRONT', 'BACK']," +
        "    DRIVING_LICENSE: ['FRONT', 'BACK']" +
        "  }," +
        "  onComplete: function(data) {" +
        "    outputListenerHandler.postMessage(JSON.stringify(data));" +
        "  }," +
        "  onError: function(error) {" +
        "    errorListenerHandler.postMessage(JSON.stringify(error));" +
        "  }," +
        "  onUserExit: function() {" +
        "    errorListenerHandler.postMessage(JSON.stringify({type: 'exit'}));" +
        "  }" +
        "});" +
        "})();";

    view.evaluateJavascript(script, null);
}
```

> **v7 breaking change:** `onError` now receives an object `{ code, stack }` instead of a plain string. Use `JSON.stringify(error)` to pass the full error object to native code.

## Step 5: Handle the Result

In your `OutputListener`, parse the JSON to extract captured images:

```java
@JavascriptInterface
public void postMessage(String message) {
    try {
        JSONObject result = new JSONObject(message);
        JSONArray images = result.getJSONArray("images");

        for (int i = 0; i < images.length(); i++) {
            JSONObject img = images.getJSONObject(i);
            String base64Data = img.getString("data");
            String type = img.getString("type");
            // Process base64-encoded PNG image
        }
    } catch (JSONException e) {
        Log.e("AutoCapture", "Failed to parse output", e);
    }
}
```

## Troubleshooting

- **"Failed to fetch worker script"** — `fetch()` is blocked on `file://`. Use `WebViewAssetLoader` to serve via `https://`.
- **Black screen, no camera** — Missing camera permission. Request `CAMERA` permission at runtime.
- **Camera permission denied in JS** — `onPermissionRequest` not implemented. Override `WebChromeClient.onPermissionRequest`.
- **SDK loads but no assets** — Wrong `ASSETS_FOLDER` path. Must match the `WebViewAssetLoader` path exactly.
