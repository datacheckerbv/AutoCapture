# Web Integration Examples for AutoCapture

Integrate AutoCapture into your web projects using one of three methods: Script Tag, NPM, or React. Each method is designed to suit different project setups and requirements.

## Integration Methods

### 1. Script Tag

Easily add AutoCapture to your HTML files using the Script Tag method.

```html
<!-- Add AutoCapture directly in your HTML -->
<script src="../dist/autocapture.obf.js"></script>
```

### 2. NPM

For projects using NPM and a module bundler like Webpack or Rollup, you can import AutoCapture as an ES6 module or with CommonJS require syntax.

```bash
npm install --save @datachecker/autocapture
```

```js
// Import AutoCapture in your JavaScript file

// ES6 style import
import AutoCapture from '@datachecker/autocapture';

// CommonJS style require
let AutoCapture = require('@datachecker/autocapture')
```

For more detailed NPM integration examples, refer to the [NPM examples section](npm/npm.md).

### 3. React

Integrating AutoCapture into React applications is straightforward with ES6 module import or with CommonJS require syntax. These approaches are perfect for projects created with Create React App or similar React frameworks.

```bash
npm install --save @datachecker/autocapture
```

```js
// Import AutoCapture in your React component

// ES6 style import
import AutoCapture from '@datachecker/autocapture';

// CommonJS style require
let AutoCapture = require('@datachecker/autocapture')
```

For additional React-specific examples, check out the [React examples section](react/react.md).
