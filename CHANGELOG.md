# *CHANGELOG*

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
