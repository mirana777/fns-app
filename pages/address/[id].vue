<template>
  <div class="flex-1 p-4">
    <AddressBar :address="relation.address" :domains="relation.domains" />
    <el-alert
      v-if="relation.domains.length"
      :title="`Primary FNS Name (reverse record): ${relation.domains[0]}`"
      type="success"
      description="You can register more names"
      class="!mb-4"
      :closable="false"
      show-icon
    />
    <el-alert
      v-else
      title="Primary FNS Name (reverse record): not set"
      type="warning"
      description="You can register a name"
      class="!mb-4"
      :closable="false"
      show-icon
    />

    <el-tabs type="border-card" class="rounded overflow-hidden">
      <el-tab-pane>
        <template #label>
          <span class="flex-center">
            <el-icon><UserFilled /></el-icon>
            <span class="ml-1">Registrant</span>
          </span>
        </template>
        <AddressTabRegisteredDomains :data="relation.registrant" />
      </el-tab-pane>
      <el-tab-pane label="地址">
        <template #label>
          <span class="flex-center">
            <el-icon><User /></el-icon>
            <span class="ml-1">Controller</span>
          </span>
        </template>
        <AddressTabManagedDomains :data="relation.controller" />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup lang="ts">
import API from '~/libs/api'
import { NoteError } from '~~/composables'
import { eventHub } from '~~/libs/event-hub'

const loading = ref(true)
const route = useRoute()

const relation = reactive({
  address: route.params.id,
  domains: [],
  registrant: [],
  controller: []
})

async function getAddressRelation() {
  try {
    loading.value = true
    const names = await API.findNamesViaAddress(relation.address)
    if (!names) return
    relation.domains = Array.isArray(names) ? names : [names]
  } catch (error) {
    NoteError('Get reverse record error !')
  } finally {
    loading.value = true
  }
}

eventHub.on('update', getAddressRelation)
onUnmounted(() => eventHub.off('update'))
onMounted(getAddressRelation)
</script>
