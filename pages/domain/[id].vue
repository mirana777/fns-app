<template>
  <div v-loading="loading" element-loading-text="Loading..." class="flex-1 p-4">
    <DomainBar :name="$route.params.id" :address="domain.address" :available="domain.available" />
    <el-tabs v-model="activeTab" type="border-card" class="rounded overflow-hidden">
      <el-tab-pane name="base">
        <template #label>
          <span class="flex-center">
            <el-icon><DocumentCopy /></el-icon>
            <span class="ml-1">Base</span>
          </span>
        </template>
        <DomainTabInfo :domain="domain" @register="activeTab = 'register'" />
      </el-tab-pane>

      <el-tab-pane name="text">
        <template #label>
          <span class="flex-center">
            <el-icon><Tickets /></el-icon>
            <span class="ml-1">Text</span>
          </span>
        </template>
        <DomainTabText />
      </el-tab-pane>

      <el-tab-pane v-if="domain.available && accountStore.connected" name="register">
        <template #label>
          <span class="flex-center">
            <el-icon><SetUp /></el-icon>
            <span class="ml-1">Register</span>
          </span>
        </template>
        <DomainTabRegister :domain="domain" />
      </el-tab-pane>

      <el-tab-pane v-if="domain.mine && accountStore.connected">
        <template #label>
          <span class="flex-center">
            <el-icon><Setting /></el-icon>
            <span class="ml-1">Resolver</span>
          </span>
        </template>
        <DomainTabResolver :domain="domain" />
      </el-tab-pane>

      <el-tab-pane v-if="domain.mine && accountStore.connected">
        <template #label>
          <span class="flex-center">
            <el-icon><Setting /></el-icon>
            <span class="ml-1">Content</span>
          </span>
        </template>
        <DomainTabContent :domain="domain" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup lang="ts">
import { TipError } from '~~/composables'
import API from '~~/libs/api'
import { eventHub } from '~~/libs/event-hub'
import { useAccountStore } from '~~/store'

const accountStore = useAccountStore()
const loading = ref(true)
const route = useRoute()
const activeTab = ref('base')

const domain = reactive({
  name: route.params.id,
  content: '',
  address: '',
  available: false,
  parent: 'fil',
  registrant: '',
  controller: '',
  expires: '',
  mine: false
})

async function getName() {
  try {
    loading.value = true
    const Name = await API.getNameInfo(domain.name)

    domain.available = Name.available
    domain.address = Name.address
    domain.expires = Name.expires
    domain.content = Name.contenthash
    domain.controller = Name.controller
    domain.registrant = Name.registrant
    domain.mine = domain.registrant.toLowerCase() === accountStore.$state.account.toLowerCase()
  } catch (error) {
    TipError('Networ Error !')
  } finally {
    loading.value = false
  }
}

eventHub.on('update', getName)
onUnmounted(() => eventHub.off('update'))
onMounted(getName)
</script>
