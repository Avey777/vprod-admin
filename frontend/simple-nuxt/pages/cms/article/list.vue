<script lang="ts" setup>
import { getArticleList } from "@/api/cms/article";
import type { ArticleInfo } from "@/api/cms/model/articleModel";

const articles = ref<ArticleInfo[]>([]);
const hotArticles = ref<ArticleInfo[]>([]);
const page = ref<number>(1);
const pageSize = ref<number>(10);
const total = ref<number>(0);

onMounted(() => {
  getArticleListData();
  getHotArticleListData();
});

function getArticleListData() {
  getArticleList({
    page: page.value,
    pageSize: pageSize.value,
  }).then((res) => {
    articles.value = res.data.data;
    total.value = res.data.total;
  });
}

function getHotArticleListData() {
  getArticleList({
    page: page.value,
    pageSize: pageSize.value,
    sort: "hot",
  }).then((res) => {
    hotArticles.value = res.data.data;
  });
}
</script>
<template>
  <NuxtLayout>
    <el-row class="mt-4">
      <el-col :span="16" :sm="24" :md="24" :lg="16">
        <el-card class="box-card w-full">
          <template #header>
            <div class="card-header">
              <el-text size="large" tag="b">{{
                $t("cms.articleList")
              }}</el-text>
            </div>
          </template>
          <el-card
            v-for="item in articles"
            :key="item.id"
            class="mt-2"
            @click="
              navigateTo('/cms/article/' + item.id, {
                open: { target: '_blank' },
              })
            "
          >
            <el-row>
              <el-col :span="18">
                {{ item.title }}
              </el-col>
              <el-col :span="3">
                <Icon name="ph:eye-bold" class="pr-3 text-neutral-500" />
                <el-text size="small"> {{ item.hit }}</el-text>
              </el-col>
              <el-col :span="3">
                <Icon name="ph:user-bold" class="pr-3 text-neutral-500" />
                <el-text size="small"> {{ item.author }}</el-text>
              </el-col>
            </el-row>
          </el-card>

          <template #footer>
            <el-pagination
              v-model:current-page="page"
              layout="prev, pager, next"
              :total="total"
              :page-size="pageSize"
              @current-change="getArticleListData()"
            />
          </template>
        </el-card>
      </el-col>
      <el-col :span="7" :sm="0" :md="0" :lg="7" :offset="1">
        <el-row>
          <el-card class="w-full">
            <template #header>
              <div class="card-header">
                <el-text size="large" tag="b">{{
                  $t("cms.hotArticles")
                }}</el-text>
              </div>
            </template>
            <el-row v-for="item in hotArticles" :key="item.id"
              ><el-button
                link
                @click="
                  navigateTo('/cms/article/' + item.id, {
                    open: { target: '_blank' },
                  })
                "
                >{{ item.title }}</el-button
              ></el-row
            >
          </el-card>
        </el-row>
      </el-col>
    </el-row>
  </NuxtLayout>
</template>
