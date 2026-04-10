# React Integration Examples for AutoCapture

You can import the libary as a module into your own JS build system (tested with React). We offer two different setups: using our assets via a Content Delivery Network (CDN) or hosting them locally. Both of these examples have been thoroughly tested with Webpack and are designed to be easily integrated into most JavaScript build systems.

Please take a look at the example files for more information on implementation.

## Prerequisites

Before you begin, ensure you have [Node.js](https://nodejs.org/) installed on your system. This will provide you with Node Package Manager (npm), essential for managing the dependencies in your project.

## Working with React

### Import

```javascript
import AutoCapture from '@datachecker/autocapture';
```

### Configuration

Please refer to the [Configuration](../../../README.md#configuration) reference.

```javascript
const AutoCaptureComponent = () => {
  const initialized = useRef(false);

  useEffect(() => {
    // Initialized only once
    if (!initialized.current) {
      initialized.current = true;
      const AC = new AutoCapture();
      AC.init({
        CONTAINER_ID: 'AC_mount',
        LANGUAGE: 'en',
        TOKEN: "<SDK_TOKEN>",
        onComplete: function(data) {
          console.log(data);
        },
        onError: function(error) {
          // v7: error is { code, stack }
          console.log(error.code, error.stack);
        },
        onUserExit: function(error) {
          console.log(error);
        }
      });
    }
  }, []);

  return (
    <div id="AC_mount" />
  );
}
```

### Working with Typescript

Create a file autocapture.d.ts & copy the following type definition and extend it according to your use case.

```ts
declare module '@datachecker/autocapture' {
  export type AutocaptureResponse = {
    images: string[];
    face?: {
      score: number;
      data: string;
    };
  };

  export type CapturedImage = {
    data: string;
    type: string;
    additional_document_type?: string;
  };

type AllowedDocumentSides = Array<'FRONT' | 'BACK'>;
type AllowedDocuments = {
    IDENTITY_CARD?: AllowedDocumentSides;
    PASSPORT?: AllowedDocumentSides;
    DUTCH_PASSPORT?: AllowedDocumentSides;
    RESIDENCE_PERMIT?: AllowedDocumentSides;
    DRIVING_LICENSE?: AllowedDocumentSides;
};

  interface AutoCaptureConfig {
    CONTAINER_ID: string;
    LANGUAGE: string;
    TOKEN: string;
    ASSETS_MODE?: 'CDN' | 'LOCAL';
    ASSETS_FOLDER?: string;
    ALLOWED_DOCUMENTS?: AllowedDocuments;
    APPROVAL?: boolean;
    DEBUG?: boolean;
    DESKTOP_MODE?: boolean;
    BACKGROUND_COLOR?: string;
    ROI_MODE?: 'portrait-landscape' | 'landscape-landscape';
    SDK_MODE?: 'autocapture' | 'papercapture';
    CAPTURE_BTN_AFTER?: number;
    onComplete: (data: AutocaptureResponse) => void;
    onError: (error: { code: string; stack: string }) => void;
    onUserExit: (error: string) => void;
  }

  class AutoCapture {
    constructor();
    init(config: AutoCaptureConfig): Promise<void>;
    stop(): void;
    remove(): void;
  }

  export default AutoCapture;
}
```

## Using examples

### Example Using React with CDN

To test our package with assets delivered via CDN, follow these steps:

1. **Navigate to the CDN Example Directory:**

   Open your terminal and change to the `react_cdn` directory, which contains the CDN-based example project.

   ```bash
   cd react_cdn
   ```

2. **Install Dependencies:**

   Use npm to install the project dependencies.

   ```bash
   npm install
   ```

3. **Build and Run the Example Project:**

   Compile the example project using the following command:

   ```bash
   npm start
   ```

   This step integrates our package into the example project using CDN.

### Example Using React Locally

If you prefer to test our package with locally hosted assets, here's how you can set up the local example:

1. **Navigate to the Local Example Directory:**

   In your terminal, switch to the `react_local` directory, which contains the local asset-based example project.

   ```bash
   cd react_local
   ```

2. **Install Dependencies:**

   Just as before, install the necessary dependencies using npm.

   ```bash
   npm install
   ```

3. **Copy assets**

    Copy the assets from the `node_modules` directory into the example project `public` directory.

    ```bash
    cp -r node_modules/@datachecker/autocapture/dist/assets public/assets
    ```

4. **Build and Run the Example Project:**

   Build the example project with this command:

   ```bash
   npm start
   ```
