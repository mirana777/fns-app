<template>
  <div
    class="flex justify-between items-center p-4 text-xl font-mono mb-4 border rounded bg-[#F5F7FA] text-blue-600"
  >
    <div class="flex-center text-xl font-mono">
      <el-icon class="mr-2"><Switch /></el-icon>
      {{ address }}
      <template v-if="domains.length">
        <el-icon class="mx-2"><Back /></el-icon>
        <el-tag v-for="d in domains" :key="d" class="mr-1" :type="success" effect="dark">{{
          d
        }}</el-tag>
      </template>
    </div>

    <span class="flex-center hover:(opacity-80 underline)">
      <a
        :href="`https://wallaby.filfox.info/address/${address}`"
        target="_blank"
        class="cur-pointer text-sm"
        >View on Explorer</a
      >
      <el-icon size="15" class="ml-1"><Right /></el-icon>
    </span>
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{ address?: string; domains?: string[] }>(), {
  address: '',
  domains: () => []
})
</script>
