module.exports = {
  apps: [
    {
      name: 'app.filns.domains',
      script: './.output/server/index.mjs',
      env: {
        NUXT_HOST: '0.0.0.0',
        PORT: 3333
      }
    }
  ]
}
