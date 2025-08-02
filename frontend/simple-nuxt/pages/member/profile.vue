<script lang="ts" setup>
const store = useMemberStore();

function logout() {
  store.logout();
}
</script>
<template>
  <NuxtLayout>
    <div class="profile">
      <el-row>
        <el-col :span="10" :offset="7">
          <el-card>
            <el-row class="flex justify-center">
              <el-avatar :src="store.avatar" :size="120"></el-avatar>
            </el-row>
            <el-row class="flex justify-center mt-4">
              <el-text size="large">{{ store.nickname }}</el-text>
            </el-row>
            <el-row class="flex justify-center mt-4">
              <el-tag effect="dark" type="warning" round>{{
                store.rankName
              }}</el-tag>
            </el-row>
            <el-row class="flex justify-center mt-4">
              <el-button size="default" type="danger" @click="logout()">{{
                $t("member.logout")
              }}</el-button>
            </el-row>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </NuxtLayout>
</template>
