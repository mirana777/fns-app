<template>
  <div class="min-h-screen flex flex-col">
    <Header />
    <div class="flex-1 flex items-stretch bg-[##F0F6FA]">
      <LeftMenu />
      <slot></slot>
    </div>
  </div>
</template>
