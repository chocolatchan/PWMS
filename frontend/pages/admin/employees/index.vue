<script setup lang="ts">
const employees = ref([
  { id: 1, code: 'EMP001', name: 'John Doe', role: 'Admin', status: 'Active' },
  { id: 2, code: 'EMP002', name: 'Jane Smith', role: 'Staff', status: 'Active' },
  { id: 3, code: 'EMP003', name: 'Bob Johnson', role: 'QA', status: 'Inactive' },
])

const columns = [{
  key: 'code',
  label: 'Code'
}, {
  key: 'name',
  label: 'Name'
}, {
  key: 'role',
  label: 'Role'
}, {
  key: 'status',
  label: 'Status'
}, {
  key: 'actions',
  label: 'Actions'
}]
</script>

<template>
  <div class="space-y-6">
    <div class="flex justify-between items-center">
      <h1 class="text-2xl font-bold">Employees</h1>
      <UButton icon="i-heroicons-plus" label="Add Employee" />
    </div>

    <UCard>
      <UTable :rows="employees" :columns="columns">
        <template #status-data="{ row }">
          <UBadge :color="row.status === 'Active' ? 'green' : 'red'" variant="subtle">
            {{ row.status }}
          </UBadge>
        </template>
        
        <template #actions-data="{ row }">
          <UButton color="gray" variant="ghost" icon="i-heroicons-pencil-square" />
          <UButton color="gray" variant="ghost" icon="i-heroicons-trash" />
        </template>
      </UTable>
    </UCard>
  </div>
</template>
