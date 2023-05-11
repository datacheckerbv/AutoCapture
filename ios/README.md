# AutoCapture - iOS integration

This guide provides step-by-step instructions on how to integrate the AutoCapture web application into an iOS app using WKWebView.

Please note that AutoCapture is a web-based tool written in JavaScript. Before proceeding with the iOS integration, make sure to familiarize yourself with the JavaScript documentation to understand how to configure the tool. The following instructions will guide you through running the JavaScript code within a Swift environment.

## Installation

1. Clone repo

```bash
git clone git@github.com:datacheckerbv/AutoCapture.git
```

2. Move `ios/index.html` to `html/index.html`

```bash
cd AutoCapture
mv ios/index.html html/index.html
```

3. Import AutoCapture in your Xcode project.

4. Create a AutoCapture View Controller

## Usage

Inside the `AutoCaptureViewController`, you can start the script using webView.evaluateJavaScript(script, completionHandler: nil).

Here's an example of how to integrate AutoCapture into your iOS app:

```
let script = """
            let AC = new AutoCapture();
            AC.init({
                CONTAINER_ID: 'AC_mount',
                LANGUAGE: 'en',
                MODELS_PATH:"\(modelURL)",
                MRZ: true,
                MRZ_RETRIES: 5,
                onComplete: function(data) {
                    window.webkit.messageHandlers.output.postMessage(data);
                    AC.stop();
                },
                onError: function(error) {
                    AC.stop();
                    AC.alert(error);
                }
            }).then(() => {
                // Tap to start
                document.addEventListener('touchstart', AC.start)
                window.onclick = AC.start
            });
"""

webView.evaluateJavaScript(script, completionHandler: nil)
```

Make sure to replace `modelURL` with the actual URL of the models needed for AutoCapture. Also replace `token` with a valid token.

These steps will enable you to integrate the AutoCapture web application seamlessly into your iOS app using the WKWebView component.
