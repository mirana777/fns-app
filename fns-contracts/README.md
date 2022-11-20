# filns-contracts

FilNS contracts

## Deployments

FNSRegistry: 0xD7E020247e1e1686F50Bb4246Ca1AdFDC4609723
ReverseRegistrar: 0x77317202e1e03FdEAd3c15733b137576075F8878
Registrar: 0x34bE6E7dc684D4515F7fCc5D5581809664cEBbd4
FixedPriceOracle: 0x11087e901dCF6C40772d733E0891Cd8C9e84Eba1
RegistrarController: 0x017896C0e02684e09f0bD9a30A97948fFd5d3B52
PublicResolver: 0x17ff100bE841fE8dE04B3b5BD1B87Eaf67b7bd79

## Build

```
yarn install
yarn compile
```

## Show accounts

```
yarn hardhat accounts
```

## Deploy FNS contracts

```
cp .env.example .env
config PRIVATE_KEY in .env
yarn hardhat deploy --tags resolver
```

## Show deployed contracts

```
yarn hardhat fns-contracts
```