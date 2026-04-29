<script setup lang="ts">
const greetMsg = ref("");
const name = ref("");

async function greet() {
  const { invoke } = await import("@tauri-apps/api/core");
  greetMsg.value = await invoke("greet", { name: name.value });
}
</script>

<template>
  <UApp>
    <UContainer class="py-10 flex flex-col items-center gap-8">
      <h1 class="text-4xl font-bold">Welcome to Nuxt UI v4 + Tauri</h1>

      <div class="flex gap-8 items-center">
        <a href="https://nuxt.com" target="_blank" class="flex flex-col items-center gap-2">
          <UIcon name="i-logos-nuxt-icon" class="w-20 h-20 transition-all hover:drop-shadow-[0_0_2em_#00DC82]" />
          <span class="font-semibold text-[#00DC82]">Nuxt 4</span>
        </a>
        <a href="https://tauri.app" target="_blank" class="flex flex-col items-center gap-2">
          <img src="/tauri.svg" class="h-20 transition-all hover:drop-shadow-[0_0_2em_#24c8db]" alt="Tauri logo" />
          <span class="font-semibold text-[#24c8db]">Tauri</span>
        </a>
        <a href="https://vuejs.org/" target="_blank" class="flex flex-col items-center gap-2">
          <img src="/vue.svg" class="h-20 transition-all hover:drop-shadow-[0_0_2em_#42b883]" alt="Vue logo" />
          <span class="font-semibold text-[#42b883]">Vue 3</span>
        </a>
      </div>

      <p class="text-gray-500">Click on the Nuxt and Tauri logos to learn more.</p>

      <form class="flex gap-2" @submit.prevent="greet">
        <UInput v-model="name" placeholder="Enter a name..." />
        <UButton type="submit">Greet</UButton>
      </form>

      <p class="text-lg font-medium">{{ greetMsg }}</p>
    </UContainer>
  </UApp>
</template>
