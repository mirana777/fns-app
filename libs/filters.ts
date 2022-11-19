import BigNumber from 'bignumber.js/bignumber.mjs'
import { BigNumber as BN } from 'ethers'
import moment from 'moment'

export function formatUnits(value: any, decimals = 18, digits = decimals, simple = false) {
  // check for ethers' BigNumber
  if (BN.isBigNumber(value)) {
    value = value.toString()
  }
  value = new BigNumber(value as any)
  // is 0 ?
  if (value.eq(0)) {
    return '0'
  }

  const units = toFixed(value.div(10 ** decimals), digits)
  if (digits < decimals && Number(units) < 1 / 10 ** digits && simple) {
    return '<' + `0.${'1'.padStart(digits, '0')}`
  }
  return units
}

export function formatEther(value: any) {
  return formatUnits(value)
}

export function formatEstimatePercent(value: any) {
  return (
    (new BigNumber(value).lt(0.0001) ? '<0.01' : new BigNumber(value).times(100).toFixed(2)) + '%'
  )
}

export function formatTime(timestamp: number, formatter = 'YYYY-MM-DD HH:mm:ss', unix = true) {
  return unix ? moment.unix(timestamp).format(formatter) : moment(timestamp).format(formatter)
}

export function toFixed(value: number | string | BigNumber, digits = 0) {
  if (value < 1 && value > 0) {
    return new BigNumber(value)
      .toFixed()
      .replace(new RegExp(`^(0.0*[1-9][0-9]{${digits - 1}}).*`), '$1')
      .replace(/0+$/, '')
  }
  return new BigNumber(value)
    .times(10 ** digits)
    .dp(0, BigNumber.ROUND_DOWN)
    .div(10 ** digits)
    .toFixed()
}

export function formatAssetValue(
  balance: string | number | BN,
  price: string | number,
  decimals = 18,
  digits = decimals
) {
  if (balance === undefined) {
    return '0'
  }

  if (BN.isBigNumber(balance)) {
    balance = balance.toString()
  }
  return new BigNumber(balance)
    .div(10 ** decimals)
    .times(price)
    .times(10 ** digits)
    .dp(0)
    .div(10 ** digits)
    .toFixed(digits)
}

export const formatAddress = (address: string, num = 4) => {
  if (address.endsWith('.zks')) return address
  return address.slice(0, num + 2) + '...' + address.slice(-num)
}
