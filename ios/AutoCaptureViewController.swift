//
//  AutoCaptureViewController.swift
//  Datachecker
//
//  Created by Fabian Afatsawo on 23/05/2023.
//

import UIKit
import WebKit

class AutoCaptureViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    private var htmlFileURL: URL!
    private var modelUrl: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        htmlFileURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "html")!
        modelUrl = htmlFileURL.deletingLastPathComponent().appendingPathComponent("models")
        setupWebView()
        webView.loadFileURL(htmlFileURL, allowingReadAccessTo: htmlFileURL.deletingLastPathComponent())
    }
    
    private func setupWebView() {
        // Configures the WKWebView by creating a web configuration, enabling inline media playback,
        // and setting up the user content controller with message handlers and scripts.
        // Adds the WKWebView as a subview and sets up its constraints.
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.userContentController = configureUserContentController()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureUserContentController() -> WKUserContentController {
        // Configures the WKUserContentController with message handlers for logging and custom output.
        // Also adds a user script for overriding console.log and other console methods.
        // Returns the configured WKUserContentController.
        
        let userContentController = WKUserContentController()
        userContentController.add(self, name: "output")
        userContentController.add(LoggingMessageHandler(), name: "logging")
        userContentController.addUserScript(configureOverrideConsoleScript())
        return userContentController
    }
    
    private func configureOverrideConsoleScript() -> WKUserScript {
        // Returns a WKUserScript containing JavaScript code that overrides console.log, console.warn,
        // console.error, console.debug in the WKWebView and sends log messages to the logging message handler.
        
        let overrideConsoleScript = """
            // JavaScript code for overriding console.log, console.warn, console.error, console.debug

            function log(emoji, type, args) {
                window.webkit.messageHandlers.logging.postMessage(
                    `${emoji} JS ${type}: ${Object.values(args)
                        .map(v => typeof(v) === "undefined" ? "undefined" : typeof(v) === "object" ? JSON.stringify(v) : v.toString())
                        .map(v => v.substring(0, 3000)) // Limit msg to 3000 chars
                        .join(", ")}`
                );
            }

            let originalLog = console.log;
            let originalWarn = console.warn;
            let originalError = console.error;
            let originalDebug = console.debug;

            console.log = function() { log("📗", "log", arguments); originalLog.apply(null, arguments); };
            console.warn = function() { log("📙", "warning", arguments); originalWarn.apply(null, arguments); };
            console.error = function() { log("📕", "error", arguments); originalError.apply(null, arguments); };
            console.debug = function() { log("📘", "debug", arguments); originalDebug.apply(null, arguments); };

            window.addEventListener("error", function(e) {
                log("💥", "Uncaught", [`${e.message} at ${e.filename}:${e.lineno}:${e.colno}`]);
            });
        """

        return WKUserScript(source: overrideConsoleScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }

}

extension AutoCaptureViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Handles messages received from JavaScript in the WKWebView.
        // Logs the received message and dismisses the view controller.
        
        guard let dict = message.body as? [String: AnyObject] else {
            return
        }
        print(dict)
        dismiss(animated: true, completion: nil)
    }
}

extension AutoCaptureViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Called when the WKWebView finishes loading the HTML content.
        // Executes JavaScript code in the WKWebView to initialize the face detection process,
        // listen for completion or error events, and send output data back to the native code.
        
        let script = """
            window.AC = new Autocapture();
            window.AC.init({
                CONTAINER_ID: 'AC_mount',
                LANGUAGE: 'en',
                MRZ: false,
                CHECK_TOTAL:5,
                CROP_CARD: true,
                MODELS_PATH:"\(modelURL)",
                onComplete: function (data) {
                    window.webkit.messageHandlers.output.postMessage(data);
                    window.AC.stop()
                },
                onError: function(error) {
                    console.log(error)
                    window.AC.stop();
                    window.AC.alert(error)
                }
            })
        """
        
        webView.evaluateJavaScript(script, completionHandler: nil)
    }
}

class LoggingMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Handles messages received from JavaScript in the WKWebView for logging purposes.
        // Logs the received message.
        
        print(message.body)
    }
}
