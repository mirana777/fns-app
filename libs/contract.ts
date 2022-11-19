import { ethers } from 'ethers'
import { wallet } from '~/libs/wallet'
import { CONTRACT_ADDRESS } from '~~/constants'
import FNSRegistryAbi from '~~/constants/abi/FNSRegistry.json'
import IRegistrarAbi from '~~/constants/abi/IRegistrar.json'
import IRegistrarControllerAbi from '~~/constants/abi/IRegistrarController.json'
import PublicResolverAbi from '~~/constants/abi/PublicResolver.json'
import ReverseRegistrarAbi from '~~/constants/abi/ReverseRegistrar.json'

// 单例模式
let ContractFNSRegistry = null
let ContractIRegistrar = null
let ContractIRegistrarController = null
let ContractPublicResolver = null
let ContractReverseRegistrar = null

export async function useContractFNSRegistry() {
  if (!ContractFNSRegistry) {
    const provider = await wallet.getWeb3Provider()
    ContractFNSRegistry = new ethers.Contract(
      CONTRACT_ADDRESS.FNSRegistry,
      FNSRegistryAbi,
      provider
    ) as any
  }
  return ContractFNSRegistry
}

export async function useContractIRegistrar() {
  if (!ContractIRegistrar) {
    const provider = await wallet.getWeb3Provider()
    ContractIRegistrar = new ethers.Contract(
      CONTRACT_ADDRESS.Registrar,
      IRegistrarAbi,
      provider
    ) as any
  }
  return ContractIRegistrar
}

export async function useContractIRegistrarController() {
  if (!ContractIRegistrarController) {
    const provider = await wallet.getWeb3Provider()
    ContractIRegistrarController = new ethers.Contract(
      CONTRACT_ADDRESS.RegistrarController,
      IRegistrarControllerAbi,
      provider.getSigner()
    ) as any
  }

  return ContractIRegistrarController
}

export async function useContractPublicResolver() {
  if (!ContractPublicResolver) {
    const provider = await wallet.getWeb3Provider()
    ContractPublicResolver = new ethers.Contract(
      CONTRACT_ADDRESS.PublicResolver,
      PublicResolverAbi,
      provider.getSigner()
    ) as any
  }
  return ContractPublicResolver
}

export async function useContractReverseRegistrar() {
  if (!ContractReverseRegistrar) {
    const provider = await wallet.getWeb3Provider()
    ContractReverseRegistrar = new ethers.Contract(
      CONTRACT_ADDRESS.ReverseRegistrar,
      ReverseRegistrarAbi,
      provider
    ) as any
  }
  return ContractReverseRegistrar
}
