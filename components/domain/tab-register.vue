<template>
  <el-alert
    title="Reminder"
    type="warning"
    description="Increase registration period to avoid paying gas every year !"
    class="!mb-4"
    :closable="false"
    show-icon
  />
  <div
    v-loading="loading"
    class="py-10 rounded bg-[#F5F7FA] text-gray-500 select-none"
    element-loading-text="Submitting..."
  >
    <div class="flex-center mb-10 text-2xl font-mono">
      Register
      <el-icon
        class="ml-4 cursor-pointer hover:opacity-70 transition"
        size="35"
        @click="registerYear > 1 && registerYear--"
        ><Remove
      /></el-icon>
      <input
        v-model="registerYear"
        readonly
        class="outline-none border-b border-red-400 bg-transparent text-red-400 text-center mx-4 w-20"
      />
      <el-icon class="cursor-pointer hover:opacity-70 transition" size="35" @click="registerYear++"
        ><CirclePlus
      /></el-icon>
      <span class="ml-4">{{ registerYear < 2 ? 'Year' : 'Years' }}</span>
      <el-icon class="mx-4"><Switch /></el-icon>
      <div class="text-red-400 flex-center">
        <count-to
          :start-val="feeFromTo[0]"
          :end-val="feeFromTo[1]"
          :duration="1000"
          :decimals="4"
          class="mr-1"
        ></count-to>
        TFIL
      </div>
    </div>
    <div class="flex-center">
      <el-button plain type="primary" class="mr-2" @click="resetRegister">Reset</el-button>
      <el-button type="primary" @click="submitRegister">Submit</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { formatUnits } from '@ethersproject/units'
import { CountTo } from 'vue3-count-to'
import { TipError, TipSuccess } from '~~/libs/utils'
import API from '~~/libs/api'
import { useAccountStore } from '~~/store'

const accountStore = useAccountStore()
const route = useRoute()
const loading = ref(false)
const registerYear = ref(1)
const estimateFee = ref('')
const feeFromTo = ref([0, 0])

async function computeRegisterFee() {
  const name = route.params.id
  const duration = registerYear.value * 365 * 86400 // 秒
  const fee = await API.estimateTxFee(name, duration)
  estimateFee.value = formatUnits(fee.base)
}

function resetRegister() {
  registerYear.value = 1
}

async function submitRegister() {
  try {
    loading.value = true

    const name = route.params.id
    const owner = accountStore.$state.account
    const duration = registerYear.value * 365 * 86400 // 秒

    await API.registerName(name, owner, duration, estimateFee.value)
    TipSuccess('Submitted, waiting for 1-2 minutes to take effect !')
    resetRegister()
  } catch (error) {
    TipError('Register Error !')
    console.error(error)
  } finally {
    loading.value = false
  }
}

function setRegisterFee(val, _val) {
  if (isNaN(+_val) || isNaN(+val)) return
  feeFromTo.value = [+_val, +val]
}

watch(registerYear, computeRegisterFee)
watch(() => estimateFee.value, setRegisterFee)
onMounted(computeRegisterFee)
</script>

<style scoped lang="less"></style>
