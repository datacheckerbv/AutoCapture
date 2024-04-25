const path = require('path');
const CopyPlugin = require('copy-webpack-plugin');

module.exports = {
  mode: 'development',
  entry: './index.js',
  experiments: {
    outputModule: true
  },
  output: {
    libraryTarget:'module',
    path: path.resolve(__dirname, 'release'),
    filename: 'bundle.js',
  },
  plugins: [
    new CopyPlugin({
      patterns: [
        { from: 'node_modules/@datachecker/autocapture/dist/assets', to: 'assets' },
      ],
    }),
  ],
};