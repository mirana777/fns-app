module.exports = {
  extends: ['@nuxtjs/eslint-config-typescript', 'plugin:prettier/recommended'],
  rules: {
    'prettier/prettier': [
      'error',
      {
        tabWidth: 2, // tab 宽度
        singleQuote: true, // 单引号
        trailingComma: 'none', // 对象末尾无逗号
        printWidth: 100, // 单行字符上限
        semi: false, // 句末无分号
        bracketSpacing: true, // 对象和数组首尾留空格
        arrowParens: 'avoid', // 箭头函数单参数省略括号
        insertPragma: false, // 文件顶部无需 @format 标记
        useTabs: false, // 使用空格而非缩进符
        endOfLine: 'auto' // 兼容 Windows 换行
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
