<template>
  <div v-loading="loading" class="p-2" element-loading-text="Submitting...">
    <el-descriptions
      border
      title="This domain is unavailable now"
      :column="1"
      size="large"
      direction="horizontal"
    >
      <template #title>
        <el-alert
          v-if="domain.available"
          title="Available"
          type="success"
          show-icon
          :closable="false"
        />
        <el-alert v-else title="Unavailable" type="warning" show-icon :closable="false" />
      </template>
      <template v-if="domain.available && accountStore.connected" #extra>
        <el-button type="primary" icon="SetUp" @click="$emit('register')">Register Now</el-button>
      </template>
      <el-descriptions-item label="Parent" class-name="font-mono">fil</el-descriptions-item>
      <el-descriptions-item label="Registrant" class-name="!text-gray-900">
        {{ domain.registrant }}
        <el-icon
          v-if="domain.registrant"
          class="transform translate-y-0.5 cursor-pointer hover:opacity-70"
          @click="Copy(domain.registrant)"
          ><CopyDocument /></el-icon
      ></el-descriptions-item>
      <el-descriptions-item label="Controller" class-name="!text-gray-900">
        {{ domain.controller }}
        <el-icon
          v-if="domain.controller"
          class="transform translate-y-0.5 cursor-pointer hover:opacity-70"
          @click="Copy(domain.controller)"
          ><CopyDocument
        /></el-icon>
      </el-descriptions-item>
      <el-descriptions-item label="Resolve to" class-name="!text-blue-600"
        >{{ domain.address }}
        <el-icon
          v-if="domain.address"
          class="transform translate-y-0.5 cursor-pointer hover:opacity-70"
          @click="Copy(domain.address)"
          ><CopyDocument /></el-icon
      ></el-descriptions-item>
      <el-descriptions-item label="Content" class-name="!text-blue-600">{{
        domain.content
      }}</el-descriptions-item>
      <el-descriptions-item label="Expiration date" label-class-name="w-64">
        <div v-if="!domain.available" class="flex-center justify-start">
          <el-tag :type="'danger'">{{ domain.expires }}</el-tag>
          <el-button
            v-if="!domain.available && accountStore.connected"
            class="ml-2"
            size="small"
            type="primary"
            icon="Clock"
            :disabled="activeNames[0] == 'extend'"
            @click="activeNames = ['extend']"
            >Extend</el-button
          >
        </div>
      </el-descriptions-item>
    </el-descriptions>
    {{ accountStore.collected }}
    <!-- Extend fee -->
    <el-collapse
      v-if="!domain.available && accountStore.connected"
      v-model="activeNames"
      class="mt-8"
    >
      <el-collapse-item name="extend">
        <template #title>
          <div
            class="font-semibold text-blue-600 text-base flex-center hover:opacity-70 transition"
          >
            <el-icon size="20" class="mr-1"><Clock /></el-icon>Extend
          </div>
        </template>
        <div class="py-10 rounded bg-[#F5F7FA] text-gray-500">
          <div class="flex-center mb-10 text-2xl font-mono">
            Extend
            <el-icon
              class="ml-4 cursor-pointer hover:opacity-70 transition"
              size="35"
              @click="extendYear > 1 && extendYear--"
              ><Remove
            /></el-icon>
            <input
              v-model="extendYear"
              readonly
              class="outline-none border-b border-red-400 bg-transparent text-red-400 text-center mx-4 w-20"
            />
            <el-icon
              class="cursor-pointer hover:opacity-70 transition"
              size="35"
              @click="extendYear++"
              ><CirclePlus
            /></el-icon>
            <span class="ml-4">{{ extendYear < 2 ? 'Year' : 'Years' }}</span>
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
            <el-button plain type="info" class="mr-2" @click="cannelExtend">Cancel</el-button>
            <el-button type="primary" @click="submitExtend">Submit</el-button>
          </div>
        </div>
      </el-collapse-item>
    </el-collapse>
  </div>
</template>

<script setup lang="ts">
import { formatUnits } from '@ethersproject/units'
import { CountTo } from 'vue3-count-to'
import { Copy, TipError, TipSuccess } from '~~/libs/utils'
import API from '~~/libs/api'
import { useAccountStore } from '~~/store'

const props = withDefaults(defineProps<{ domain?: any }>(), { domain: () => {} })
const accountStore = useAccountStore()
const loading = ref(false)
const extendYear = ref(1)
const activeNames = ref(['1'])
const estimateFee = ref('')
const feeFromTo = ref([0, 0])

async function computeRenewFee() {
  const { name } = props.domain
  const duration = extendYear.value * 365 * 86400 // 秒
  const fee = await API.estimateTxFee(name, duration)
  estimateFee.value = formatUnits(fee.base)
}

function cannelExtend() {
  activeNames.value = ['1']
  extendYear.value = 1
}

async function submitExtend() {
  try {
    loading.value = true

    const name = props.domain.name
    const duration = extendYear.value * 365 * 86400 // 秒

    await API.renewName(name, duration, estimateFee.value)
    TipSuccess('Submitted, waiting for 1-2 minutes to take effect !')
  } catch (error) {
    TipError('Submit failed !')
  } finally {
    loading.value = false
  }
}

function setRenewFee(val, _val) {
  if (isNaN(+_val) || isNaN(+val)) return
  feeFromTo.value = [+_val, +val]
}

watch(() => extendYear.value, computeRenewFee)
watch(() => estimateFee.value, setRenewFee)
onMounted(computeRenewFee)
</script>
