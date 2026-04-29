<script setup lang="ts">
definePageMeta({
  middleware: [
    function (to, from) {
      return navigateTo('/login')
    }
  ]
})
</script>

<template>
  <div>Redirecting to login...</div>
</template>
