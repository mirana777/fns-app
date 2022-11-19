import { defineStore } from 'pinia'

export const useAccountStore = defineStore('account', {
  state: () => ({
    chainId: '',
    account: ''
  }),
  getters: {
    shortAccount: state => {
      if (!state.account) return '...'
      return `${state.account.slice(0, 6)}...${state.account.slice(-4)}`
    },
    connected: state => !!state.account,
    rightNetwork: state => {
      return state.chainId === '0x7ab7'
    },
    network: state => {
      return state.chainId === '0x7ab7' ? 'Wallaby Testnet' : 'Error'
    }
  },
  actions: {
    setAccount(account: string) {
      this.account = account.toLowerCase()
    },
    setNetwork(chainId: string) {
      this.chainId = chainId
    }
  }
})
