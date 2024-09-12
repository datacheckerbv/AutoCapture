# *CHANGELOG*

## *CHANGES* v4.0.3

This is a major update. If you are currently using version 3, there is a [migration guide](docs/migration_guide_v4.md) available to help you transition to version 4.

### Breaking Changes

- **Removal Crop card**: Removed the capability of cropping the card in the output image (`CROP_CARD`). The output image will be the roi area oriented to the card.
- **Internal OCR Removed**: The internal OCR has been removed due to performance concerns. However, hybrid OCR functionality remains available. Because of this, the following `MRZ_SETTINGS` are deprecated: [`FLIP`, `FLIP_EXCEPTION`, `FLIP_INCLUDE`, `OCR`, `RTW`]. As be seen, the `FLIP` configurations now moved from `MRZ_SETTINGS` to `ALLOWED_DOCUMENTS`.
- **Removal of `CAPTURE_BTN_AFTER`**: The `CAPTURE_BTN_AFTER` setting has been removed.
- **Removal of `GLARE_LIVE_CHECK`**: The `GLARE_LIVE_CHECK` setting has been removed. A glare check will always be performed.

### Improvements

- **New detection model**: Improved the detection model, it now will perform card detection and quality control.
- **New allowed documents setting**: You can now use the `ALLOWED_DOCUMENTS` setting to enable or disable flipping of certain documents. Please refer to the [ALLOWED DOCUMENTS](README.md#allowed-documents) section for more details.

## *CHANGES* v3.1.5

- **Enhanced MRZ detection**: Improved capability to detect the presence of MRZ on document.

## *CHANGES* v3.1.4

- **Optimized `opencv.js` Size**: Reduced the size of `opencv.js`, resulting in faster loading times.
- **Added SIMD Support**: `opencv.js` now supports SIMD (Single Instruction, Multiple Data) for enhanced performance.
- **Efficiency Improvements**: Made minor efficiency fixes, leading to a smoother process.
- **Enhanced Camera Filtering**: Improved camera filtering based on `facingMode` and `focusMode` capabilities.
- **Updated Compatibility Requirements**: The SDK requires at least ECMAScript 12 (ES12). Please refer to the [Compatibility](README.md#compatibility) section for more details.
- **Bug Fix**: Resolved issues related to adaptive exposure.
- **Bug Fix**: Resolved focus issues with incorrect camera selection by refining focus mode criteria.

## *CHANGES* v3.1.3

- Bugfix: The new document detector introduced in version `v3.1.0` was not properly utilized.

## *CHANGES* v3.1.2

- Bugfix: Resolved an issue where AutoCapture (version 3.1.0 and above) failed to load on iOS devices.

## *CHANGES* v3.1.1

- Bugfix: Fixed an issue where conflicts occurred when loading different ONNX engines in the same environment, such as when different SDKs are used simultaneously.

## *CHANGES* v3.1.0

- Decreased size of `autocapture.obf.js` by 8.38 MiB, resulting in faster loading time.
- New document detector, documents without MRZ can now be captured before their other side with MRZ.
- Improved UI/UX.
- Changed notifications. (see [Languages](README.md#languages))
- Capture button configuration. (see [Configuration](README.md#configuration))
- Camera selection is now possible. This can be used as a fallback when the automatic back camera detection fails.
- Clean-up codebase.

- Bugfix: No Camera access native iOS now throws the expected error.

## *CHANGES* v3.0.2

- Bugfix: Personal number was not returned in NLD / BEL ID docs.

## *CHANGES* v3.0.1

- Add V3 migration guide

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
