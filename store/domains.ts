import { defineStore } from 'pinia'
import { getStoredDomainsFromLocal, removeDomainFromLocal, storeDomainToLocal } from '~/libs/utils'
import { TipSuccess } from '~~/composables'

export const useDomainsStore = defineStore('domains', {
  state: () => ({
    storedDomains: []
  }),
  getters: {},
  actions: {
    storeDomain(domain: string) {
      if (!domain) return

      if (!this.storedDomains.includes(domain)) {
        this.storedDomains.push(domain)
        storeDomainToLocal(domain)
        TipSuccess('Add favorites successfully')
      } else {
        this.storedDomains = this.storedDomains.filter(d => d !== domain)
        removeDomainFromLocal(domain)
        TipSuccess('Remove favorites successfully')
      }
    }
  },
  hydrate(state) {
    state.storedDomains = getStoredDomainsFromLocal()
  }
})
