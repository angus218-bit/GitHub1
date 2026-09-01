import js from '@eslint/js';
import globals from 'globals';
import react from 'eslint-plugin-react';

export default [
  { ignores: ['dist/**', 'node_modules/**'] },
  js.configs.recommended,
  {
    files: ['**/*.{js,jsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parserOptions: { ecmaFeatures: { jsx: true } },
      globals: { ...globals.browser, ...globals.node },
    },
    plugins: { react },
    settings: { react: { version: 'detect' } },
    rules: {
      'react/jsx-uses-react': 'off',
      'react/react-in-jsx-scope': 'off',
      'react/jsx-uses-vars': 'error',
      'no-unused-vars': ['warn', { argsIgnorePattern: '^_' }],
    },
  },
];
