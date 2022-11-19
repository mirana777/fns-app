<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>

<script setup lang="ts">
import { wallet } from '~/libs/wallet'
import { useDomainsStore } from '~/store'
useDomainsStore()
onMounted(() => wallet.connect())
</script>
