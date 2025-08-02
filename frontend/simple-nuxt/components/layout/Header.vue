<template>
  <div>
    <el-row class="h-6">
      <el-col :span="4" :offset="2">
        <el-image
          src="/images/simple-nuxt.png"
          alt="Simple Nuxt"
          class="h-8 pt-1"
          @click="navigateTo('/')"
        />
      </el-col>
      <el-col :span="4" :offset="9" class="flex items-center justify-end">
        <el-button link @click="navigateTo('/cms/article/list')">{{
          $t("cms.articleList")
        }}</el-button>
      </el-col>
      <el-col :span="4" :offset="1" class="flex items-center">
        <el-button
          v-if="store.token === ''"
          link
          @click="navigateTo('/member/register')"
          >{{ $t("member.register") }}</el-button
        >
        <el-button
          v-if="store.token === ''"
          @click="navigateTo('/member/login')"
          >{{ $t("member.login") }}</el-button
        >

        <el-button
          v-if="store.token !== ''"
          round
          @click="navigateTo('/member/profile')"
          >{{ store.nickname }}</el-button
        >

        <el-dropdown class="pl-2">
          <el-button link>
            <Icon name="ion:language" size="1.5em" />
          </el-button>
          <template #dropdown>
            <el-dropdown-menu v-model="language">
              <el-dropdown-item @click="setLocale('zh-CN')"
                >简体中文</el-dropdown-item
              >
              <el-dropdown-item @click="setLocale('en-US')"
                >English</el-dropdown-item
              >
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </el-col>
    </el-row>
    <el-divider />
  </div>
</template>
<script lang="ts" setup>
const { locale, setLocale } = useI18n();
const language = ref<string>(locale.value);

const store = useMemberStore();
</script>
