<template>
  <div class="home flex-1 flex-col flex-center bg-blue-400">
    <Logo class="w-64" />
    <h1 class="mt-5 mb-16 text-white text-shadow-xl text-6xl font-thin">FILECOIN NAME SERVICE</h1>
    <HomeSearch class="w-2/3" />
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'home' })
</script>

<style scoped lang="less">
.home {
  background: url('~/assets/imgs/2.svg') no-repeat left top,
    url('~/assets/imgs/3.svg') no-repeat right bottom,
    url('~/assets/imgs/1.svg') no-repeat center center / 100%,
    url('~/assets/imgs/home-bg.svg') no-repeat center center / auto 90%,
    linear-gradient(100deg, #194fc9, rgb(133, 133, 239));
}
</style>
