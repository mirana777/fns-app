<template>
  <div class="flex-center text-white font-light">
    <template v-if="accountStore.connected">
      <el-tag effect="dark" :type="accountStore.rightNetwork ? 'success' : 'danger'" class="mr-2">{{
        accountStore.network
      }}</el-tag>
      {{ accountStore.shortAccount }}
    </template>
    <div
      class="border border-white rounded-md px-6 py-1 ml-4 transition cursor-pointer hover:(text-blue-500 bg-white)"
      @click="accountStore.connected ? wallet.disconnect() : wallet.connect()"
    >
      {{ accountStore.connected ? 'Disconnect' : 'Connect Wallet' }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { wallet } from '~/libs/wallet'
import { useAccountStore } from '~/store'
const accountStore = useAccountStore()
</script>
