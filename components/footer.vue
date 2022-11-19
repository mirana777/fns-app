<template>
  <div class="flex-center h-10 border">Footer</div>
</template>

<script setup lang="ts">
// import {} from ''

const props = withDefaults(
  defineProps<{
    show?: boolean
  }>(),
  { show: false }
)
</script>

<style scoped lang="less"></style>
