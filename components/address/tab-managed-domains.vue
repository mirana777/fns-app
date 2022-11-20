<template>
  <div class="flex flex-col items-end">
    <el-table ref="tableRef" size="large" row-key="date" :data="data">
      <template #empty>
        <el-empty description="No domain name managed by this address" />
      </template>
      <el-table-column
        prop="domain"
        label="Domain"
        sortable
        column-key="date"
        class-name="font-mono"
      />

      <el-table-column prop="registrant" label="Registrant" align="center" sortable>
        <template #default="scope">
          <el-tag disable-transitions>{{ scope.row.registrant }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="expires" label="Expires" align="center" sortable>
        <template #default="scope">
          <el-tag :type="'warning'" disable-transitions>{{ scope.row.expires }}</el-tag>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination
      class="mt-4 transform translate-x-4"
      layout="prev, pager, next"
      :total="data.length"
    />
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{ data?: any[] }>(), { data: () => [] })
</script>
