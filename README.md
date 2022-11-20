# fns-app

NOTE:  In order to obey rules of hackthon and facilitate project submission, merge the fns-contracts code repo into fns-app, the original repo link is https://github.com/mirana777/fns-contracts

FNS is a decentralized name service based on the Filecoin EVM. It resolves Metadata into easy-to-read xxx.fil names. fns.fil subdomains (such as alice.fns.fil) are distinguished from other domains by non-transferable SBT to ensure identity uniqueness. 

Look at the [nuxt 3 documentation](https://v3.nuxtjs.org) to learn more.

## Setup

Make sure to install the dependencies:

```bash
# yarn
yarn install

# npm
npm install

# pnpm
pnpm install --shamefully-hoist
```

## Development Server

Start the development server on http://localhost:3000

```bash
npm run dev
```

## Production

Build the application for production:

```bash
npm run build
```

Locally preview production build:

```bash
npm run preview
```

Checkout the [deployment documentation](https://v3.nuxtjs.org/guide/deploy/presets) for more information.