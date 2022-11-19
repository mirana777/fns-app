import { ethers } from 'ethers'
import detectEthereumProvider from '@metamask/detect-provider'
import { ElNotification } from 'element-plus'
import { NoteError } from './utils'
import { useAccountStore } from '~~/store'

class Wallet {
  public provider!: any
  public wallet!: any

  public async connect() {
    try {
      const web3Provider = await this.getWeb3Provider()
      if (!web3Provider) return

      if (web3Provider.provider.chainId !== 0x7ab7) {
        await this.switchNetwork()
      }

      const chainId = await web3Provider.provider.request({ method: 'eth_chainId' })
      const accounts = await web3Provider.provider.request({ method: 'eth_requestAccounts' })
      useAccountStore().setAccount(accounts[0])
      useAccountStore().setNetwork(chainId)

      this.bindEvents()
    } catch (error) {
      console.error('error', error)
      ElNotification({
        title: 'Error',
        message: 'Install Metamask and connect first !',
        type: 'error'
      })
    }
  }

  public bindEvents() {
    this.provider.on('chainChanged', () => {
      NoteError('Chain Error !')
      window.location.reload()
    })

    this.provider.on('disconnect', () => {
      NoteError('Wallet disconnected !')
      window.location.reload()
    })
  }

  public disconnect() {
    const accountStore = useAccountStore()
    accountStore.setAccount('')
    accountStore.setNetwork('')
  }

  public async switchNetwork() {
    const web3Provider = await this.getWeb3Provider()
    await web3Provider.provider.request({
      method: 'wallet_addEthereumChain',
      params: [
        {
          chainId: '0x7ab7',
          chainName: 'Filecoin Wallaby',
          rpcUrls: ['https://wallaby.filfox.info/rpc/v0'],
          blockExplorerUrls: ['https://wallaby.filfox.info'],
          nativeCurrency: {
            name: 'tFIL',
            symbol: 'tFIL',
            decimals: 18
          }
        }
      ]
    })
    await web3Provider.provider.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId: '0x7ab7' }]
    })
  }

  public async getWeb3Provider() {
    if (!this.provider) {
      const _provider = (await detectEthereumProvider()) as any
      if (_provider) {
        this.provider = new ethers.providers.Web3Provider(_provider)
      }
    }

    return this.provider
  }
}

export const wallet = new Wallet()
