module.exports = {
  extends: ['@nuxtjs/eslint-config-typescript', 'plugin:prettier/recommended'],
  rules: {
    'prettier/prettier': [
      'error',
      {
        tabWidth: 2,
        singleQuote: true,
        trailingComma: 'none',
        printWidth: 100,
        semi: false,
        bracketSpacing: true,
        arrowParens: 'avoid',
        insertPragma: false,
        useTabs: false,
        endOfLine: 'auto'
      }
    ],

    'no-console': 'off',
    'no-useless-constructor': 'off',
    'vue/no-mutating-props': 'off',
    'vue/no-v-model-argument': 'off',
    'vue/multi-word-component-names': 'off',
    'vue/no-multiple-template-root': 'off',
    'vue/no-v-for-template-key': 'off',
    'import/no-named-as-default-member': 'off',
    'import/no-named-as-default': 'off',
    'import/namespace': 'off'
  }
}
