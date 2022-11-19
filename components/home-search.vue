<template>
  <div class="h-18 flex flex-center items-stretch shadow-light-700">
    <input
      v-model.trim="input"
      type="text"
      maxlength="100"
      placeholder="Input address or domain"
      class="flex-1 px-6 text-2xl text-gray-600 border-2 border-transparent outline-none rounded-l-md font-extralight tracking-wider opacity-80"
      @keydown.enter="skip"
    />
    <div
      class="bg-[#194fc9] w-3/24 min-w-28 flex-center cursor-pointer rounded-r-md transition opacity-80 hover:opacity-100"
      @click="skip"
    >
      <IconSearch class="h-8 text-white" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { useSearchStore } from '~/store'
import { SEARCH_TYPE_ADDRESS, SEARCH_TYPE_DOMAIN } from '~~/constants'
import { isAddress, TipWarning } from '~~/libs/utils'

const searchStore = useSearchStore()
const input = ref('')
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

function skip() {
  if (!searchContent.value) {
    TipWarning('The search content cannot be empty !')
    return
  }

  searchStore.setSearchContent(searchContent.value)
  const path = inputType.value.toLowerCase()
  router.push(`/${path}/${searchContent.value}`)
}
</script>
