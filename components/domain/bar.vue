<template>
  <div
    class="flex justify-between items-center p-4 text-xl font-mono mb-4 border rounded bg-[#F5F7FA]"
    :class="[available ? 'text-green-500' : 'text-gray-400']"
  >
    <div class="flex-center">
      <el-icon v-if="available" class="mr-1"><CircleCheck /></el-icon>
      <el-icon v-else class="mr-1"><CircleClose /></el-icon>
      {{ name }}
      <template v-if="address && !available">
        <el-icon class="mx-2"><Right /></el-icon>
        <el-tag :type="success" effect="dark">{{ address }}</el-tag>
      </template>
    </div>
    <div class="flex-center">
      <span>{{ available ? 'Available' : 'Unavailable' }}</span>
      <el-icon
        class="ml-5 cursor-pointer hover:opacity-50 transition"
        size="25"
        @click="domainsStore.storeDomain(name)"
      >
        <StarFilled v-if="isDomainStored" />
        <Star v-else />
      </el-icon>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useDomainsStore } from '~/store'
const domainsStore = useDomainsStore()

const props = withDefaults(
  defineProps<{
    name?: string
    address?: string
    available?: boolean
  }>(),
  {
    name: '',
    address: '',
    available: false
  }
)

const isDomainStored = computed(() => domainsStore.$state.storedDomains.includes(props.name))
</script>
