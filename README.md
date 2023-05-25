
# AutoCapture

This project contains Datachecker's AutoCapture tool, that captures images of identity documents (ID/Passport/Driver license). The tool only takes a capture once a document is detected and it passes the quality control.

The tool will be run in the browser and is therefore written in JavaScript.

## Trigger mechanism

The tool performs the following checks:

- Is the environment not too dark (under exposure)?
- Is there a document?
- Is the detected document not too far?
- Is the detected document not too close?
- Is the image sharp?

## Configuration

To run this tool, you will need initialise with the following variables.

| **ATTRIBUTE**      | **FORMAT**          | **DEFAULT VALUE**                      | **EXAMPLE**                               | **NOTES**                                                                 |
| ------------------ | ------------------- | -------------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------- |
| `APPROVAL`         | bool                | `false`                                | `false`                                   | **optional**<br> Approval screen after capture as an extra quality check. |
| `CONTAINER_ID`     | string              |                                        | `"AC_mount"`                              | **required**<br> _div id_ to mount tool on.                               |
| `CROP_CARD`        | bool                | `false`                                | `false`                                   | **optional**<br> Enable cropping of card as output.                       |
| `GLARE_LIVE_CHECK` | bool                | `true`                                 | `true`                                    | **optional**<br> Enable glare detection.                                  |
| `LANGUAGE`         | string              | `"nl"`                                 | `"nl"`                                    | **required**<br> Notifications in specific language.                      |
| `MODELS_PATH`      | string              | `"models/"`                            | `"models/"`                               | **optional**<br> Path referring to models location.                       |
| `MRZ_SETTINGS`     | object              | see [MRZ_SETTINGS](#mrz_settings)      | see [MRZ_SETTINGS](#mrz_settings)         | **optional**<br> Settings of MRZ scanning.                                |
| `MRZ`              | bool                | `false`                                | `false`                                   | **optional**<br> Enable MRZ scanning.                                     |
| `ROOT`             | string              | `""`                                   | `"../"`                                   | **optional**<br> Root location.                                           |
| `onComplete`       | javascript function |                                        | `function(data) {console.log(data)}`      | **required**<br> Callback function on _complete_.                         |
| `onError`          | javascript function | `function(error) {console.log(error)}` | `function(error) {console.log(error)}`    | **optional**<br> Callback function on _error_.                            |
| `onImage`          | javascript function | `function(data) {console.log(data)}`   | `function(data) {console.log(data)}`      | **optional**<br> Callback function on _image_.                            |
| `onUserExit`       | javascript function | `function(error) {console.log(error)}` | `function(error) {window.history.back()}` | **optional**<br> Callback function on _user exit_.                        |

## Handling callbacks

```javascript
let AC = new AutoCapture();
AC.init({
    CONTAINER_ID: 'AC_mount',
    LANGUAGE: 'en',
    onComplete: function(data) {
        console.log(data);
        AC.stop();
    },
    onError: function(error) {
        console.log(error)
        AC.stop();
        AC.alert(error)
    },
    onUserExit: function(error) {
        console.log(error);
        AC.stop();
    }
});
```

| **ATTRIBUTE** | **FORMAT**          | **DEFAULT VALUE**                      | **EXAMPLE**                               | **NOTES**                                                                                                                                                                                           |
| ------------- | ------------------- | -------------------------------------- | ----------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `onComplete`  | javascript function |                                        | `function(data) {console.log(data)}`      | **required**<br> Callback that fires when all interactive tasks in the workflow have been completed.                                                                                                |
| `onError`     | javascript function | `function(error) {console.log(error)}` | `function(error) {console.log(error)}`    | **optional**<br> Callback that fires when an _error_ occurs.                                                                                                                                        |
| `onImage`     | javascript function | `function(data) {console.log(data)}`   | `function(data) {console.log(data)}`      | **optional**<br> Callback that fires when frame succesfully passes quality controls. This callback can be used when you want to process or analyze live frames. (See [External-MRZ](#external-mrz)) |
| `onUserExit`  | javascript function | `function(error) {console.log(error)}` | `function(error) {window.history.back()}` | **optional**<br> Callback that fires when the user exits the flow without completing it.                                                                                                            |


## Usage/Examples

The tool first needs to be initialised to load all the models.
Once its initialised, it can be started with the function `AC.start();`

```javascript
let AC = new AutoCapture();
AC.init({
    CONTAINER_ID: ...,
    LANGUAGE: ...,
    onComplete: ...,
    onError: ...,
    onUserExit: ...
}).then(() => {
    AC.start();
});
```

To stop the camera and delete the container with its contents the stop function can be called.

```javascript
...
AC.stop();
```

Example below:

```javascript
let AC = new AutoCapture();
AC.init({
    CONTAINER_ID: 'AC_mount',
    LANGUAGE: 'nl',
    onComplete: function(data) {
        console.log(data);
        AC.stop();
    },
    onError: function(error) {
        console.log(error)
        AC.stop();
        AC.alert(error)
    },
    onUserExit: function(error) {
        console.log(error);
        AC.stop();
    }
});
```

## Requirements

CSS stylesheet.

```html
<link href="css/autocapture.css" rel="stylesheet" type="text/css" />
```

The meta tags below are required to view the tool properly.

```html
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
```

Load script.

```js
<script src="js/autocapture.obf.js" type="text/javascript"></script>
```

## Demo

File present under `html/examples/index.html`

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>AutoCapture</title>
<link href="../css/autocapture.css" rel="stylesheet" type="text/css" />
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1, minimum-scale=1" />
<meta name="apple-mobile-web-app-capable" content="yes" />
</head>

<body>
    <div id="AC_mount"></div>
</body>

<script src="../js/autocapture.obf.js" type="text/javascript"></script>

<script>
    let AC = new Autocapture();
    AC.init({
        CONTAINER_ID: 'AC_mount',
        LANGUAGE: 'nl',
        ROOT: "../",
        onComplete: function (data) {
            console.log(data)
        },
        onError: function(error) {
            console.log(error)
            AC.stop();
            AC.alert(error)
        },
        onUserExit: function(error) {
            console.log(error);
            AC.stop();
        }
    });
</script>

</html>

```

## Languages

The languages can be found in `js/language/`. The current support languages are `en` and `nl`. More languages could be created.

The notifications can be loaded in `configuration` like the following:

```javascript
let AC = new AutoCapture();
AC.init({
    LANGUAGE: 'en',
    ...
```

To create support for a new language, a js file needs to be created with specific keys.
The keys can be derived from the current language js files (`js/language/en.js`).

Example:

```javascript
var LANGUAGE = {
    "start_prompt": "Tap to start",
    "flip": "Flip the document.",
    "flip_frontside": "Flip the document to the frontside.",
    "flip_backside": "Flip the document to the backside.",
    "std_msg_0": "Fill the preview window.",
    "std_msg_1": "The 4 corners of the document \nare not detected. Use \na black background for contrast.",
    "exp_dark": "The image is too dark.\nFind an environment with more light.",
    "exp_light": "The image is too light.\nFind an environment with less light.",
    "blur": "Blur detected, \nplease hold still.",
    "glare": "Glare detected, \ntilt the document slightly.",
    "size": "Bring the document closer.",
    "focus": "Focus on document.",
    "approval_prompt": "Is the image right?",
    "retry": "Try again",
    "confirm": "Accept",
    "capture_error": "We konden geen afbeelding vastleggen.\nToegang tot de camera is vereist.",
}
```

## Models

The tool uses a collection of neural networks. Make sure that you host the full directory so the models can be accessed. The models path can be configured. (see [Configuration](#configuration))
The models are located under `models/`.

## MRZ

An OCR engine is present which makes it able to do MRZ scanning. To enable MRZ scanning use `MRZ: true`(see [Configuration](#configuration)). The tool is able to scan and parse TD1, TD2, TD3 and Dutch eDL.

The MRZ scanning will start once all the quality checks are passed. It will than try to scan for a set amount of retries `MRZ_RETRIES: 5`(see [Configuration](#configuration)).
To do infinite retries use `MRZ_RETRIES: -1`.

### MRZ_SETTINGS

| **ATTRIBUTE**     | **FORMAT** | **DEFAULT VALUE** | **EXAMPLE** | **NOTES**                                                                                                                    |
| ----------------- | ---------- | ----------------- | ----------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `FLIP_EXCEPTION`  | \[string\] | `[]`              | `[P]`       | **optional**<br> If `FLIP` is `true` skip these misc values. Examples of possible misc values are: `[P, I, D]`.              |
| `FLIP`            | bool       | `true`            | `true`      | **optional**<br> Prompt user to flip card.                                                                                   |
| `MIN_VALID_SCORE` | int        | `50`              | `50`        | **optional**<br> Minimum valid score of MRZ. The valid score is a range between 0-100 indicating how valid the found MRZ is. |
| `MRZ_RETRIES`     | int        | `5`               | `5`         | **optional**<br> Amount of retries for MRZ scanning before continuing. Use `-1` for infinite retries.                        |
| `OCR`             | bool       | `true`            | `true`      | **optional**<br> Wether to use the internal OCR for MRZ reading. An external OCR can also be used see [MRZ](#mrz).           |

Example:

```javascript
let AC = new Autocapture();
AC.init({
    CONTAINER_ID: 'AC_mount',
    MRZ: true,
    MRZ_SETTINGS: {
        MRZ_RETRIES: -1,
        FLIP: true,
        FLIP_EXCEPTION: ['P'],
        MIN_VALID_SCORE: 90,
        OCR: true
    },
    onComplete: function (data) {
        console.log(data)
        AC.stop();
    },
    onError: function(error) {
        console.log(error)
        AC.stop();
        AC.alert(error)
    },
    onUserExit: function () {
        window.history.back()
    }
})
```

Example output:

```json
{   
    "angle": "...",
    "type": "PASSPORT",
    "subtype": "<",
    "country": "NLD",
    "lname": "DE",
    "lname2": "BRUIJN",
    "spacing": "",
    "fname": "WILLEKE",
    "mname1": "LISELOTTE",
    "name_complement": "",
    "number": "SPECI2014",
    "check_digit_document_number": "2",
    "nationality": "NLD",
    "date_of_birth": "1965-03-10",
    "check_digit_date_of_birth": "1",
    "sex": "F",
    "expiration_date": "2024-03-09",
    "check_digit_expiration_date": "6",
    "complement": "999999990<<<<<84",
    "mrz_type": "td3",
    "raw_mrz": [
        "P<NLDDE<BRUIJN<<WILLEKE<LISELOTTE<<<<<<<<<<<",
        "SPECI20142NLD6503101F2403096999999990<<<<<84"
    ],
    "check_digit_composite": "4",
    "personal_number": "999999990",
    "check_digit_personal_number": "8",
    "valid_number": true,
    "valid_date_of_birth": true,
    "valid_expiration_date": true,
    "valid_personal_number": true,
    "valid_composite": true,
    "valid_misc": true,
    "valid_score": 100,
    "misc": "P",
    "names": "WILLEKE LISELOTTE",
    "surname": "DE BRUIJN"
}
```

### External MRZ

MRZ can also externally be retrieved and sent to the SDK. With the `onImage` callback, an external process can be started with the current frames. If such a process succesfully retrieves the MRZ it can than be sent to the SDK with the `parse_mrz` function. An example of this function below:

```javascript
let AC = new Autocapture();
AC.init({
    ...,
    onImage: function (data) {
        console.log(data)
        let MRZ_text = EXTERNAL_OCR_FUNCTION(data) // "P<NLDDE<BRUIJN<<WILLEKE<LISELOTTE<<<<<<<<<<<\nSPECI20142NLD6503101F2403096999999990<<<<<84"
        AC.parse_mrz(text);
    },
})
```

## Output

The SDK will output in the following structure:

```json
{
    "image": "...base64_img"
}
```

With MRZ:

```json
{
    "image": "...base64_img",
    "meta": [{"angle": "..."}],
    "mrz": {
        "angle": "...",
        "type": "...",
        "subtype": "...",
        "country": "...",
        "lname": "...",
        "lname2": "...",
        "spacing": "...",
        "fname": "...",
        "mname1": "...",
        "name_complement": "...",
        "number": "...",
        "check_digit_document_number": "...",
        "nationality": "...",
        "date_of_birth": "...",
        "check_digit_date_of_birth": "...",
        "sex": "...",
        "expiration_date": "...",
        "check_digit_expiration_date": "...",
        "complement": "...",
        "mrz_type": "...",
        "raw_mrz": [
            "...",
            "..."
        ],
        "check_digit_composite": "...",
        "personal_number": "...",
        "check_digit_personal_number": "...",
        "valid_number": true,
        "valid_date_of_birth": true,
        "valid_expiration_date": true,
        "valid_personal_number": true,
        "valid_composite": true,
        "valid_misc": true,
        "valid_score": true,
        "misc": "...",
        "names": "...",
        "surname": "..."
    }
}
```

Example:

```json
{
    "image": "iVBORw0KGgoAAAANSUhEUgAAAysAAAS...",
    "meta": [{"angle": 0}],
    "mrz": {
        "angle": "...",
        "type": "PASSPORT",
        "subtype": "<",
        "country": "NLD",
        "lname": "DE",
        "lname2": "BRUIJN",
        "spacing": "",
        "fname": "WILLEKE",
        "mname1": "LISELOTTE",
        "name_complement": "",
        "number": "SPECI2014",
        "check_digit_document_number": "2",
        "nationality": "NLD",
        "date_of_birth": "1965-03-10",
        "check_digit_date_of_birth": "1",
        "sex": "F",
        "expiration_date": "2024-03-09",
        "check_digit_expiration_date": "6",
        "complement": "999999990<<<<<84",
        "mrz_type": "td3",
        "raw_mrz": [
            "P<NLDDE<BRUIJN<<WILLEKE<LISELOTTE<<<<<<<<<<<",
            "SPECI20142NLD6503101F2403096999999990<<<<<84"
        ],
        "check_digit_composite": "4",
        "personal_number": "999999990",
        "check_digit_personal_number": "8",
        "valid_number": true,
        "valid_date_of_birth": true,
        "valid_expiration_date": true,
        "valid_personal_number": true,
        "valid_composite": true,
        "valid_misc": true,
        "valid_score": 100,
        "misc": "P",
        "names": "WILLEKE LISELOTTE",
        "surname": "DE BRUIJN"
    }
}
```
