<template>
  <div class="h-13 flex flex-center items-stretch border border-[#ffffff5f] rounded-full">
    <input
      v-model.trim="input"
      type="text"
      placeholder="Input address or domain"
      class="flex-1 px-5 text-lg text-white border-transparent outline-none font-mono transition bg-transparent"
      @keydown.enter="search"
    />
    <div
      class="flex-center cursor-pointer rounded-r-md px-5 transition text-white hover:text-green-500"
    >
      <IconSearch class="h-8" @click="search" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { SEARCH_TYPE_ADDRESS, SEARCH_TYPE_DOMAIN } from '~~/constants'
import { isAddress, TipWarning } from '~~/libs/utils'
import { eventHub } from '~~/libs/event-hub'

const input = ref('')
const route = useRoute()
const router = useRouter()
const inputType = computed(() =>
  isAddress(input.value) ? SEARCH_TYPE_ADDRESS : SEARCH_TYPE_DOMAIN
)

const searchContent = computed(() => {
  let _input = input.value

  if (_input && inputType.value === SEARCH_TYPE_DOMAIN) {
    _input = /\.fil$/.test(_input) ? _input : `${_input}.fil`
  }

  return _input
})

function syncSearch() {
  input.value = route.params.id
}

function search() {
  if (!searchContent.value) {
    TipWarning('The search content cannot be empty !')
    return
  }

  if (route.params?.id === searchContent.value) {
    eventHub.emit('update')
    return
  }

  const path = inputType.value.toLowerCase()
  router.push(`/${path}/${searchContent.value}`)
}

onMounted(syncSearch)
watch(() => route.params?.id, syncSearch)
</script>
