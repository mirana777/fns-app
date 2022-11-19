import { defineStore } from 'pinia'

export const useSearchStore = defineStore('search', {
  state: () => ({
    searchContent: ''
  }),
  getters: {},
  actions: {
    setSearchContent(content: string) {
      this.searchContent = content || ''
    }
  }
})
