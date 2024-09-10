# Migration guide v4

## Configuration changes

In version 4, several configuration settings have been removed or restructured to improve performance and usability. Below is a comparison of the configuration settings between version 3 and version 4.

### Version 3

```javascript
{
    APPROVAL: true,
    ASSETS_MODE: "LOCAL",
    ASSETS_FOLDER: "dist/assets/",
    CAPTURE_BTN_AFTER: 1000, // REMOVED
    CONTAINER_ID: 'AC_mount',
    CROP_CARD: true, // REMOVED
    GLARE_LIVE_CHECK: true, // REMOVED
    LANGUAGE: 'nl',
    MRZ: true,
    MRZ_SETTINGS: {
        FLIP: true, // REMOVED
        FLIP_EXCEPTION: [], // REMOVED
        FLIP_INCLUDE: [ // REMOVED
            {
                "misc": "I",
                "country": "all",
                "nationality": "all",
            },
            {
                "misc": "D",
                "country": "all",
                "nationality": "all",
            },
            {
                "misc": "P",
                "country": "NLD",
                "nationality": "NLD",
            },
        ],
        MIN_VALID_SCORE: 90,
        MRZ_RETRIES: 5, 
        OCR: true // REMOVED
    },
    TOKEN: TOKEN,
}
```

### Version 4

The configuration changes in version 4 of the migration guide include the addition of the `ALLOWED_DOCUMENTS` object. This object specifies the allowed documents and their corresponding sides (e.g., `'FRONT'` and `'BACK'`). For documents such as `ID`, `PASSPORT`, `RESIDENCE_PERMIT`, and `DRIVING_LICENSE`, flipping is needed as there are two entries. The `DUTCH_PASSPORT` setting is undefined, which means it will be copied from the `PASSPORT` settings if it is not explicitly defined. Other configuration options such as `APPROVAL`, `ASSETS_MODE`, `ASSETS_FOLDER`, `CONTAINER_ID`, `LANGUAGE`, `MRZ`, and `TOKEN` remain the same as in version 3. `MRZ_SETTINGS` is altered where only `MIN_VALID_SCORE` and `MRZ_RETRIES` remain the same.

```javascript
{
    ALLOWED_DOCUMENTS: { // NEW
        ID: ['FRONT', 'BACK'], // Two entries, so flipping is needed
        PASSPORT: ['FRONT', 'BACK'], // Two entries, so flipping is needed
        DUTCH_PASSPORT: undefined, // Dutch passport will be copied from PASSPORT settings if undefined
        RESIDENCE_PERMIT: ['FRONT', 'BACK'], // Two entries, so flipping is needed
        DRIVING_LICENSE: ['FRONT', 'BACK'],  // Two entries, so flipping is needed
    },
    APPROVAL: true,
    ASSETS_MODE: "LOCAL",
    ASSETS_FOLDER: "dist/assets/",
    CONTAINER_ID: 'AC_mount',
    LANGUAGE: 'nl',
    MRZ: true,
    MRZ_SETTINGS: {
        MIN_VALID_SCORE: 90,
        MRZ_RETRIES: 5, 
    },
    TOKEN: TOKEN,
}
```
