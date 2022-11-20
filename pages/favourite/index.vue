<template>
  <div
    v-loading="loading"
    element-loading-text="Loading..."
    class="p-4 flex-1 flex flex-col items-end"
  >
    <el-table
      border
      size="large"
      header-cell-class-name="!bg-gray-100"
      :data="storedDomains"
      stripe
    >
      <el-table-column prop="name" label="Name" class-name="font-mono" sortable>
        <template #default="scope">
          <span class="flex-center justify-start">
            {{ scope.row.name }}
            <template v-if="scope.row.address">
              <el-icon class="mx-2"><Right /></el-icon>
              <el-tag>{{ scope.row.address }}</el-tag>
            </template>
          </span>
        </template>
      </el-table-column>
      <el-table-column prop="expires" label="Expires" align="center" width="300" sortable>
        <template #default="scope">
          <el-tag v-if="scope.row.expires" :type="'warning'" disable-transitions>{{
            scope.row.expires
          }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="available" label="Available" align="center" sortable width="200">
        <template #default="scope">
          <span v-if="scope.row.available" class="text-green-500 font-semibold flex-center text-xs">
            <el-icon size="15" class="mr-1"><SuccessFilled /></el-icon>
            Available
          </span>
          <span v-else class="text-gray-400 font-semibold flex-center text-xs">
            <el-icon size="15" class="mr-1"><WarningFilled /></el-icon>
            Unavailable
          </span>
        </template>
      </el-table-column>

      <el-table-column label="Handle" align="center" width="250">
        <template #default="scope">
          <NuxtLink :to="`/domain/${scope.row.name}`" class="mr-2.5 cursor-pointer">
            <el-button
              :type="scope.row.available ? 'success' : 'primary'"
              size="small"
              class="!w-20"
              plain
              >{{ scope.row.available ? 'Register' : 'Detail' }}</el-button
            ></NuxtLink
          >

          <el-popconfirm title="Remove ?" @confirm="domainsStore.storeDomain(scope.row.name)">
            <template #reference>
              <el-button type="danger" size="small" icon="Delete" circle plain />
            </template>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      class="mt-4 transform translate-x-4"
      layout="prev, pager, next"
      :total="storedDomains.length"
    />
  </div>
</template>

<script setup lang="ts">
import { useDomainsStore } from '~/store'
import { TipError } from '~~/composables'
import API from '~~/libs/api'

const loading = ref(false)
const domainsStore = useDomainsStore()
const storedDomains = ref([])

async function getFavouriteNames() {
  const _names = domainsStore.$state.storedDomains
  if (!_names.length) return

  try {
    loading.value = true
    const requests = _names.filter(n => n).map(API.getNameInfo)
    storedDomains.value = await Promise.all(requests)
  } catch (error) {
    TipError('Network Error !')
  } finally {
    loading.value = false
  }
}

watchEffect(getFavouriteNames)
</script>

<style scoped lang="less"></style>
