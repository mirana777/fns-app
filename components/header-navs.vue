<template>
  <ul class="text-white flex-center ml-10 list-none">
    <li class="cursor-pointer hover:(opacity-70) transition">
      <a href="https://wallaby.network/#faucet" target="_blank">Faucet</a>
    </li>
    <el-divider direction="vertical" class="!mx-6 text-gray-200" />
    <template v-for="(nav, index) in navs" :key="nav.label">
      <li class="cursor-pointer hover:(opacity-70) transition">
        <NuxtLink :to="nav.path" class="">{{ nav.label }}</NuxtLink>
      </li>
      <el-divider v-if="index < navs.length - 1" direction="vertical" class="!mx-6 text-gray-200" />
    </template>
  </ul>
</template>

<script setup lang="ts">
import { useAccountStore } from '~~/store'

const accountStore = useAccountStore()
const navs = computed(() => {
  const account = accountStore.$state.account
  if (accountStore.connected) {
    return [
      { label: 'My Account', path: `/address/${account}` },
      { label: 'Favourites', path: '/favourite' },
      { label: 'About', path: '/faq' }
    ]
  }
  return [
    { label: 'Favourites', path: '/favourite' },
    { label: 'About', path: '/faq' }
  ]
})
</script>
