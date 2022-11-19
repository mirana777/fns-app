import { defineConfig } from 'windicss/helpers'

export default defineConfig({
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        red: {},
        gray: {}
      },
      width: {},
      boxShadow: {
        default: '0 0 20px 0 rgba(0, 0, 0, 0.1)'
      },
      backgroundImage: {
        'img-sign': 'url("~/assets/img/sign.png")'
      }
    }
  },
  shortcuts: {
    shape: 'border-2 border-red-500',
    'wh-full': 'w-full h-full',
    'flex-center': 'flex items-center justify-center'
  },
  safelist: [
    range(30).map(i => `p-${i}`), // p-1 to p-30
    range(30).map(i => `mt-${i}`) // mt-1 to mt-30
  ]
})

function range(size: number, startAt = 1) {
  return Array.from(Array(size).keys()).map(i => i + startAt)
}
