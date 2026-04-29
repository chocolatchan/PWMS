<template>
  <div class="min-h-screen flex flex-col bg-gray-50 dark:bg-gray-950">
    <nav class="border-b bg-white dark:bg-gray-900 px-4 py-3 flex justify-between items-center sticky top-0 z-50">
      <div class="flex items-center gap-2">
        <UIcon name="i-heroicons-beaker" class="w-6 h-6 text-primary" />
        <span class="font-bold text-lg">PWMS</span>
      </div>
      
      <div class="flex items-center gap-4">
        <UButton color="gray" variant="ghost" icon="i-heroicons-bell" />
        <UAvatar src="https://avatars.githubusercontent.com/u/739984?v=4" size="sm" />
      </div>
    </nav>

    <div class="flex flex-1 overflow-hidden">
      <aside class="w-64 border-r bg-white dark:bg-gray-900 hidden md:flex flex-col p-4 gap-2">
        <UButton to="/admin/employees" variant="ghost" icon="i-heroicons-users" color="gray" block label="Employees" />
        <UButton to="/admin/products" variant="ghost" icon="i-heroicons-archive-box" color="gray" block label="Products" />
        <UButton to="/admin/locations" variant="ghost" icon="i-heroicons-map-pin" color="gray" block label="Locations" />
        <UDivider class="my-2" />
        <UButton to="/staff/inbound" variant="ghost" icon="i-heroicons-arrow-down-tray" color="gray" block label="Inbound" />
        <UButton to="/staff/outbound" variant="ghost" icon="i-heroicons-arrow-up-tray" color="gray" block label="Outbound" />
        <UButton to="/staff/relocate" variant="ghost" icon="i-heroicons-arrows-right-left" color="gray" block label="Relocate" />
        <UDivider class="my-2" />
        <UButton to="/qa/inspection" variant="ghost" icon="i-heroicons-clipboard-document-check" color="gray" block label="Inspection" />
      </aside>

      <main class="flex-1 overflow-y-auto p-6">
        <slot />
      </main>
    </div>
  </div>
</template>
