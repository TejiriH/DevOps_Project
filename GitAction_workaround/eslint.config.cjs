// eslint.config.cjs
const eslintPluginJest = require('eslint-plugin-jest');

module.exports = [
  {
    languageOptions: {
      globals: {
        jest: 'readonly',
        browser: 'readonly',
      },
    },
    plugins: {
      jest: eslintPluginJest,  // Include the jest plugin explicitly
    },
    rules: {
      // ESLint recommended rules
      'no-unused-vars': 'warn',
      'no-console': 'off',

      // Jest plugin rules
      'jest/no-disabled-tests': 'warn',
      'jest/no-focused-tests': 'error',
      'jest/no-identical-title': 'error',
      'jest/valid-expect': 'error',
    },
  },
  {
    files: ['*.js'],  // Apply this configuration to JavaScript files
  },
];





