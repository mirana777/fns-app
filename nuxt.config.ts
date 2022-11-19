// https://v3.nuxtjs.org/api/configuration/nuxt.config
export default defineNuxtConfig({
  css: ['~/assets/app.less'],
  buildModules: ['nuxt-windicss', '@pinia/nuxt'],
  app: {
    head: {
      meta: [
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'keywords', content: 'fns' },
        { charset: 'utf-8' }
      ]
    }
  }
})
