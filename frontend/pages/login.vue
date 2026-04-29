<script setup lang="ts">
const credentials = ref({
  username: '',
  password: ''
})

const loading = ref(false)

async function handleLogin() {
  loading.value = true
  // Mock login for now
  console.log('Logging in with:', credentials.value)
  setTimeout(() => {
    loading.value = false
    navigateTo('/admin/employees')
  }, 1000)
}
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 px-4">
    <UCard class="w-full max-w-md">
      <template #header>
        <div class="flex flex-col items-center gap-2">
          <UIcon name="i-heroicons-lock-closed" class="w-10 h-10 text-primary" />
          <h1 class="text-2xl font-bold">WMS Pharma Login</h1>
        </div>
      </template>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <UFormGroup label="Username" name="username">
          <UInput v-model="credentials.username" placeholder="admin" icon="i-heroicons-user" />
        </UFormGroup>

        <UFormGroup label="Password" name="password">
          <UInput v-model="credentials.password" type="password" placeholder="••••••••" icon="i-heroicons-key" />
        </UFormGroup>

        <UButton type="submit" block :loading="loading">
          Sign In
        </UButton>
      </form>

      <template #footer>
        <p class="text-xs text-center text-gray-500">
          GSP/GDP Compliant Warehouse Management System
        </p>
      </template>
    </UCard>
  </div>
</template>
