# *CHANGELOG*

## *CHANGES* v0.0.32
- This is a test
- For selecting the correct part
- Of this changelog

## *CHANGES* v3.0.0

- Increased max resolution to 1080x1980 for sharper output images.
- Auto-exposure for android.
- Only enable SDK when allowed in token.
- New OCR model which reduces memory footprint which caused the OCR to fail on certain Android devices.
- Android phones will only have live glare check on last frame to decrease runtime.
- Added demo token functionality.
- Restructured codebase. AutoCapture and FaceVerify can now both be loaded in the same page.
- CSS identifiers renamed.
- Notications can now be loaded as object (json) in config. (See [Languages](README.md#languages))
- Added `viewport-fit=cover` to the `<meta> 'viewport'` properties, to get fullscreen.
- Landscape mode capturing now possible.
- Repositioned Task box.
- Introduction `FLIP_INCLUDE` to only flip on certain criteria. (See [MRZ Configuration](README.md#mrz-configuration-mrz_settings))
- **Removed** Paper only option.
- Introduction `force_capture` flag, indicating which of the output images are captured by force. (See [Output](README.md#output))
- Introduction `ROI_MODE` to select a `ROI` (frame) orientation. (see [Configuration](README.md#configuration))
- Introduction `ALWAYS_FLIP` to always flip even when there is no `MRZ` scanning. (see [Configuration](README.md#configuration))
- Removal of `ROOT`. (see [Configuration](README.md#configuration))
- Refactored Codebase.
- Introduction `ASSETS_MODE` and `ASSETS_FOLDER` to fetch assets. (see [Configuration](README.md#configuration))
- Introduction `BACKGROUND_COLOR` to change background color. (see [Configuration](README.md#configuration))
- NPM install now available
- Script tag import, ES6 style import and CommonJS style import. (see [Importing SDK](README.md#importing-sdk))
- Version control between Assets and Main file. (see [Version control](README.md#version-control))
- Customizable background color. (see [Configuration](README.md#configuration))
- Meta tags are now added automatically.
- Detailed integration examples. (see [Examples](examples/README.md))
- Renamed module `Autocapture` to `AutoCapture`.
- Decreased package size by removing redundant files.

- Bugfix: Short camera glitch on startup iOS.
- Bugfix: Notifications could not be updated twice.
- Bugfix: iOS back cameras are not switching anymore.
- Bugfix: Size check is now depended on the area with respect to the ROI rather than the pixel area.
- Bugfix: Resizing screen caused an error on force capture.
- Bugfix: Wait until opencv is ready.

## *CHANGES* v2.0.1

- Created [Changelog](#changelog), moved previous logging of changes from [README](README.md) to [Changelog](#changelog).
- Readme addition of [Prerequisites](README.md#prerequisites), [OAuth Token](README.md#oauth-token), [Steps](README.md#steps).
- Moved Readme [SDK Token](README.md#sdk-token).
- [Handling callbacks](README.md#handling-callbacks) are now all **required** instead of **optional**.
- Missing **required** settings will throw an error. (see [Configuration](README.md#configuration))
- Now, errors will be thrown when images are missing.
- Improved underexposure check.
- Added Debug logging. (see [Configuration](README.md#configuration))
- Rewritten documentantion on MRZ scanning. (see [MRZ](README.md#mrz))
- Rewritten documentantion on [Android integration](/android/README.md).

- Bugfix: Task still visibile after completed proces. Task now will be hidden.
- Bugfix: WASM SIMD not supported on all devices. Added more WASM support files.

## *CHANGES* v2.0.0

**BREAKING CHANGE!**

Please note: The migration from V1 to V2 is a breaking change. The outputs are changed and the SDK is locked with a token.

- Added Token with validation. Application can only be started with a valid token. (see [SDK Token](README.md#sdk-token), [Configuration](README.md#configuration))
- Added cropping of face. (see [Configuration](README.md#configuration), [Output](README.md#output))
- Portrait mode requirement, landscape will throw an alert.
- New Tap-to-start screen.
- New flip animations.
- Added Android integration documentation at `android/`.

## *CHANGES* v1.1.0

- Added paper document detection. (see [Configuration](README.md#configuration))
- New UI.
- Decreased size ONNX engine.
- Glare classification instead of segmentation.
