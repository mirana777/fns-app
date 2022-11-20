<template>
  <div
    v-loading="loading"
    class="px-4 py-10 flex flex-col items-center rounded"
    element-loading-text="Submitting..."
  >
    <div class="w-2/3 lg:w-1/2">
      <el-alert type="success" :closable="false" class="!p-5">
        <template #title>
          <span class="flex-center justify-start">
            <span class="text-2xl font-semibold font-mono">{{ domain.name }}</span>
            <template v-if="address">
              <el-icon class="mx-2"><Right /></el-icon>
              <el-tag effect="dark" type="success">{{ address }}</el-tag>
            </template>
          </span>
        </template>
        <span class="text-sm font-extralight"
          >Please set the address associated with this domain name</span
        >
      </el-alert>
      <el-input
        ref="addressInput"
        v-model="address"
        maxlength="50"
        class="mt-5"
        size="large"
        :clearable="true"
        placeholder="Association String"
      >
        <template #prepend>
          <div class="min-w-32 text-center font-bold">Address</div>
        </template>
      </el-input>
      <div class="mt-10 flex-center">
        <el-button plain type="primary" @click="resetAddress">Reset</el-button>
        <el-button type="primary" :disabled="!address" @click="submitAddress">Submit</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { TipError, TipSuccess } from '~~/libs/utils'
import API from '~~/libs/api'
const props = withDefaults(defineProps<{ domain?: any }>(), { domain: () => {} })

const loading = ref(false)
const addressInput = ref(null)
const address = ref(props.domain.address)

async function submitAddress() {
  try {
    loading.value = true
    await API.setAddress(props.domain.name, address.value)
    TipSuccess('Submitted, waiting for 1 - 2 minutes to take effect !')
  } catch (error) {
    TipError('Submit Error !')
    console.error(error)
  } finally {
    loading.value = false
  }
}

function resetAddress() {
  address.value = ''
  addressInput.value.focus()
}
</script>
