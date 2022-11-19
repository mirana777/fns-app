<template>
  <div class="flex items-center h-20 bg-[#194fc9] px-10">
    <Logo class="mr-4" />
    <HeaderNavs v-if="$route.path === '/'" />
    <HeaderSearch v-else class="flex-1 mr-1/12" />
    <ConnectWallet class="ml-auto" />
  </div>
</template>
