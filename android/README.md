# Android Integration Guide for AutoCapture Web App

Welcome to the Android Integration Guide for AutoCapture Web App. This guide will lead you through the process of seamlessly integrating a JavaScript-based web app into your Android application. By following these steps, you'll be able to harness the full functionality of the AutoCapture tool within your Android app.

Please note that AutoCapture is a web-based tool developed using JavaScript. Before diving into the Android integration process, it's important to acquaint yourself with the JavaScript documentation to gain an understanding of how to configure the tool. The instructions provided here will walk you through the process of executing JavaScript code within a Java environment.

## Prerequisites

Before you begin, ensure you have the following:

- Android Studio installed on your development machine.
- The AutoCapture web app that you intend to integrate into your Android app.

## Step 1: Setting up the Android Project

### 1.1 **Launch Android Studio and Create a New Project**

 Begin by opening Android Studio and either creating a new project or opening an existing one where you wish to integrate the web app.

### 1.2 **Adding Permissions in Manifest**

In your AndroidManifest.xml file, add the necessary permissions for your web app to function properly.

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### 1.3 **Setting up the Assets Folder**

Create an `assets` folder within your Android app project. To do this, right-click on your app module, navigate to New > Folder > Asset Folder, and create the asset folder. Then, copy the necessary SDK files into this folder.

## Step 2: Preparing the Activity to Run JavaScript SDK

### 2.1 **Requesting Camera Access Permissions**

Prior to utilizing the camera within your web app, ensure you request the necessary permissions from the user.

### 2.2 **Configuring WebView**

Inside the `onCreate()` method of your activity, configure the `WebView` to load and display your web app. This involves enabling JavaScript, setting up the asset loader, and configuring various settings.

```java
WebSettings webSettings = webView.getSettings();
webSettings.setJavaScriptEnabled(true);
webSettings.setMediaPlaybackRequiresUserGesture(false);

// Configure asset loader
final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
        .addPathHandler("/assets/", new WebViewAssetLoader.AssetsPathHandler(this))
        .addPathHandler("/res/", new WebViewAssetLoader.ResourcesPathHandler(this))
        .build();

// Set WebView client
webView.setWebViewClient(new LocalContentWebViewClient(assetLoader));

// Add JavaScript interface
webView.addJavascriptInterface("<Add your listner class here>");

// Set WebChromeClient for console messages and permissions
webView.setWebChromeClient(new WebChromeClient() {
    @Override
    public boolean onConsoleMessage(ConsoleMessage consoleMessage) {
        '<For printing logs>'
        return true;
    }

    @Override
    public void onPermissionRequest(final PermissionRequest request) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            request.grant(request.getResources());
        }
    }
});

// Load the web app URL
webView.loadUrl("https://appassets.androidplatform.net/assets/index.html");
```

### 2.3 **Creating LocalContentWebViewClient**

Define a private class `LocalContentWebViewClient` extending `WebViewClientCompat` to handle Javascript logging.

```java
private class LocalContentWebViewClient extends WebViewClientCompat {

    private final WebViewAssetLoader mAssetLoader;

    LocalContentWebViewClient(WebViewAssetLoader assetLoader) {
        mAssetLoader = assetLoader;
    }

    @Override
    public void onPageStarted(WebView view, String url, Bitmap favicon) {
        super.onPageStarted(view, url, favicon);
        String script = "\"\"\n" +
                "            function log(emoji, type, args) {\n" +
                "              window.outPutMessageHandler.postMessage(\n" +
                "                `${emoji} JS ${type}: ${Object.values(args)\n" +
                "                  .map(v => typeof(v) === \"undefined\" ? \"undefined\" : typeof(v) === \"object\" ? JSON.stringify(v) : v.toString())\n" +
                "                  .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars\n" +
                "                  .join(\", \")}`\n" +
                "              )\n" +
                "            }\n" +
                "        \n" +
                "            let originalLog = console.log\n" +
                "            let originalWarn = console.warn\n" +
                "            let originalError = console.error\n" +
                "            let originalDebug = console.debug\n" +
                "        \n" +
                "            console.log = function() { log(\"\uD83D\uDCD7\", \"log\", arguments); originalLog.apply(null, arguments) }\n" +
                "            console.warn = function() { log(\"\uD83D\uDCD9\", \"warning\", arguments); originalWarn.apply(null, arguments) }\n" +
                "            console.error = function() { log(\"\uD83D\uDCD5\", \"error\", arguments); originalError.apply(null, arguments) }\n" +
                "            console.debug = function() { log(\"\uD83D\uDCD8\", \"debug\", arguments); originalDebug.apply(null, arguments) }\n" +
                "        \n" +
                "            window.addEventListener(\"error\", function(e) {\n" +
                "               log(\"\uD83D\uDCA5\", \"Uncaught\", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`])\n" +
                "            })\n" +
                "        \"\"";

        view.evaluateJavascript(script, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String s) {
                Log.d("JavaScript onPageStart", s);
            }
        });
    }

    @Override
    public void onPageFinished(WebView view, String url) {
        super.onPageFinished(view, url);
        pageLoadFinished(view);

    }

    @Override
    @RequiresApi(21)
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        WebResourceRequest request) {
        return mAssetLoader.shouldInterceptRequest(request.getUrl());
    }



    @Override
    @SuppressWarnings("deprecation") // to support API < 21
    public WebResourceResponse shouldInterceptRequest(WebView view,
                                                        String url) {
        return mAssetLoader.shouldInterceptRequest(Uri.parse(url));
    }
}
```

### 2.4 **JavaScript Interface**

Define a JavaScript interface class to receive messages from JavaScript code.

```java
public class ImageListner {
    @JavascriptInterface
    public void postMessage(String message) {
        //Here you will recive the JSON containing the the images in bytes format.
    }
}
```

### 2.5 **Loading JavaScript SDK**

Configure the AutoCapture SDK and start it. The configuration requires two additional variables: `modelURL`, `TOKEN`.

First, `modelURL` indicates the location where the SDK models can be found. As explained in [2.2](#22-configuring-webview) this will be in the created `assets` folder. The modelURL will than be: `https://appassets.androidplatform.net/assets/models/`

Second, `TOKEN` needs to be replaced by a valid SDK token requested at Datachecker. Please refer to the [Token documentation](https://developer.datachecker.nl/).

As can be seen in the example below, the `postMessage` from [2.4](#24-javascript-interface) is used within the `onComplete` and `onUserExit` callback functions to handle the data.

```java
private void pageLoadFinished(WebView view) {
    if (ContextCompat.checkSelfPermission(DocumentCaptureActivity.this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_CAMERA_REQUEST_CODE);
        }
    }else  {
        String modelUrl = "https://appassets.androidplatform.net/assets/models/";

        String script = "\"\"\n" +
                "        window.AC = new Autocapture();\n" +
                "        window.AC.init({\n" +
                "            CONTAINER_ID: 'AC_mount',\n" +
                "            LANGUAGE: 'en',\n" +
                "            MRZ: false,\n" +
                "            CHECK_TOTAL:5,\n" +
                "            CROP_CARD: true,\n" +
                "            MRZ_SETTINGS: {\n" +
                "                MRZ_RETRIES: 50,\n" +
                "                FLIP: true,\n" +
                "                FLIP_EXCEPTION: ['P'],\n" +
                "                MIN_VALID_SCORE: 50,\n" +
                "                OCR: false\n" +
                "            },\n" +
                "            MODELS_PATH:\"" + modelUrl + "\",\n" +
                "            TOKEN: \"" + TOKEN + "\",\n" +
                "            onComplete: function (data) {\n" +
                "                  console.log(data);\n" +
                "                imageMessageHandler.postMessage(JSON.stringify(data));\n" +
                "                window.AC.stop()\n" +
                "            },\n" +
                "            onError: function(error) {\n" +
                "                console.log(error)\n" +
                "                window.AC.stop();\n" +
                "                window.AC.alert(error)\n" +
                "            },\n" +
                "                  onUserExit: function (data) {\n" +
                "                           window.webkit.messageHandlers.exit.postMessage(data);\n" +
                "                       }\n" +
                "                   });\n" +
                "        \"\"";

        Log.d("JavaScript SCRIPT", script);

        view.evaluateJavascript(script, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String s) {
                Log.d("JavaScriptLog", s);
            }
        });
    }
}
```

## 2.7 **Hybrid OCR**

AutoCapture's internal OCR consists of a Tesseract JS library. Unfortunately this library is big and causes memory issues when creating an android application. A solution to this is using Android native OCR together with AutoCapture. The SDK will find the document, and in a hybrid way, the Native OCR will find the MRZ. 

### 2.7.1

To work with hybrid OCR, add following dependency in your apps build.gradle file

`implementation 'org.jmrtd:jmrtd:0.7.18`

### 2.7.2

In your activity class, implement 'DCOCRResultListener' interface. It has two methods as follows.

```java
@Override
public void onSuccessMRZScan(MRZInfo mrzInfo) {
        // Here you will receive the scanned MRZ data in the object.
}

@Override
public void onFailure(Constants.ERROR_CODE error) {
// Error if MRZ Scan fails.
    Log.d("Error", error.name());
} 
```

### 2.7.3

Once you implement these methods. You need to call following function and pass it the output you received in [2.4](#24-javascript-interface).

```java
DCNFCLib dcnfcLib = new DCNFCLib(this, this);
dcnfcLib.scanImage(dataString, this);
```

In above code snippet for scanImage() method, first parameter is image dataString and other parameter is 'DCOCRResultListener'.
