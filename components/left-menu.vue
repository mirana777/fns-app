<template>
  <div class="p-4 pr-0">
    <el-menu router class="wh-full pr-6" :default-active="$route.path" active-text-color="red">
      <el-menu-item index="/">
        <el-icon><Search /></el-icon>
        <span class="text-xl font-light">Search</span>
      </el-menu-item>
      <el-menu-item
        v-if="accountStore.$state.account"
        :index="`/address/${accountStore.$state.account}`"
      >
        <el-icon><User /></el-icon>
        <span class="text-xl font-light">My Domains</span>
      </el-menu-item>
      <el-menu-item index="/faq">
        <el-icon><Finished /></el-icon>
        <span class="text-xl font-light">FAQ</span>
      </el-menu-item>
      <el-menu-item index="/favourite">
        <el-icon><Star /></el-icon>
        <span class="text-xl font-light">Favourite</span>
      </el-menu-item>
    </el-menu>
  </div>
</template>

<script setup lang="ts">
import { useAccountStore } from '~/store'
const accountStore = useAccountStore()
</script>
